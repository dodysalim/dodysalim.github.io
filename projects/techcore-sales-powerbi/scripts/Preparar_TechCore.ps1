# Windows PowerShell 5.1. No necesita permisos de administrador.
[CmdletBinding()]
param([ValidateSet('Escritorio','Movil')][string]$Vista = 'Escritorio', [switch]$NoAbrir)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Split-Path -Parent $PSScriptRoot
$projectRoot = $root
$utf8 = New-Object System.Text.UTF8Encoding($false)
$logStarted = $false

function Invoke-PbiTools {
    param([string[]]$ToolArguments)
    & $script:tool @ToolArguments
    if ($LASTEXITCODE -ne 0) {
        throw "pbi-tools termino con codigo $LASTEXITCODE. Consulta el registro."
    }
}


function Initialize-CoreCompiler {
    $coreCache = Join-Path $env:LOCALAPPDATA 'TechCore\pbi-tools-core-1.2.0'
    $script:coreExe = Join-Path $coreCache 'pbi-tools.core.exe'
    if (-not (Test-Path -LiteralPath $script:coreExe)) {
        [void](New-Item -ItemType Directory -Path $coreCache -Force)
        $archive = Join-Path $run 'pbi-tools-core.zip'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Write-Host 'Descargando el compilador independiente pbi-tools Core...'
        Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/pbi-tools/pbi-tools/releases/download/1.2.0/pbi-tools.core.1.2.0_win-x64.zip' -OutFile $archive
        Expand-Archive -LiteralPath $archive -DestinationPath $coreCache -Force
    }
    if (-not (Test-Path -LiteralPath $script:coreExe)) { throw 'No se encontro pbi-tools.core.exe.' }
    $dotnetRoot = Join-Path $env:LOCALAPPDATA 'TechCore\dotnet8'
    $dotnet = Join-Path $dotnetRoot 'dotnet.exe'
    $runtimeReady = $false
    if (Test-Path -LiteralPath $dotnet) {
        $runtimeReady = [bool]((& $dotnet --list-runtimes) -match '^Microsoft.NETCore.App 8\.')
    }
    if (-not $runtimeReady) {
        Write-Host 'Preparando .NET 8 en la carpeta de TechCore del usuario...'
        $installer = Join-Path $run 'dotnet-install.ps1'
        Invoke-WebRequest -UseBasicParsing -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile $installer
        # Proceso separado: el instalador oficial puede terminar con exit.
        & powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $installer -Runtime dotnet -Channel 8.0 -Architecture x64 -InstallDir $dotnetRoot -NoPath
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $dotnet)) { throw 'No se pudo preparar .NET 8.' }
    }
    # Variables solo para este proceso; no cambian PATH ni la configuracion del sistema.
    $env:DOTNET_ROOT = $dotnetRoot
    $env:DOTNET_ROOT_X64 = $dotnetRoot
    $env:DOTNET_MULTILEVEL_LOOKUP = '0'
}

function Invoke-CoreCompile {
    param([string]$Folder, [string]$Template)
    Initialize-CoreCompiler
    & $script:coreExe compile -folder $Folder -outPath $Template -format PBIT
    if ($LASTEXITCODE -ne 0) { throw "pbi-tools Core termino con codigo $LASTEXITCODE." }
}

function Rewrite-ModelNode {
    param($Node)
    if ($null -eq $Node) { return }
    if ($Node -is [System.Management.Automation.PSCustomObject]) {
        foreach ($property in $Node.PSObject.Properties) {
            if ($property.Value -is [string]) {
                $property.Value = Rewrite-MExpression $property.Value
            } elseif ($property.Value -is [array]) {
                $array = $property.Value
                for ($i = 0; $i -lt $array.Count; $i++) {
                    if ($array[$i] -is [string]) {
                        $array[$i] = Rewrite-MExpression $array[$i]
                    } else { Rewrite-ModelNode $array[$i] }
                }
            } else { Rewrite-ModelNode $property.Value }
        }
    }
}

function Rewrite-MExpression {
    param([string]$Text)
    # Solo fuentes locales File.Contents con ruta literal. No modifica DAX.
    $pattern = '(?i)(File\.Contents\s*\(\s*)"((?:[^"]|"")*)"'
    $evaluator = [System.Text.RegularExpressions.MatchEvaluator]{
        param($match)
        $old = $match.Groups[2].Value.Replace('""', '"')
        $name = [System.IO.Path]::GetFileName($old)
        if (-not $script:sources.ContainsKey($name)) {
            [void]$script:missing.Add($old)
            return $match.Value
        }
        $new = $script:sources[$name]
        [void]$script:changes.Add([PSCustomObject]@{Antes=$old;Despues=$new})
        # Escapes de literales M. Windows no permite comillas en nombres.
        $literal = $new.Replace('#(', '#(#)(').Replace('"', '""')
        return $match.Groups[1].Value + '"' + $literal + '"'
    }
    return [regex]::Replace($Text, $pattern, $evaluator)
}

try {
    $outputRoot = Join-Path $root '.local\generado'
    [void](New-Item -ItemType Directory -Path $outputRoot -Force)
    $run = Join-Path $outputRoot ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,6))
    [void](New-Item -ItemType Directory -Path $run)
    Start-Transcript -Path (Join-Path $run 'ejecucion.log') | Out-Null
    $logStarted = $true
    $pbix = Join-Path $projectRoot 'historico\entrega_anterior\Avances\Avance_3\Avance_3_Dashboard_PowerBI.pbix'
    $script:sources = @{
        'ventas.csv' = Join-Path $projectRoot 'datos\ventas.csv'
        'ventasTransformed.csv' = Join-Path $projectRoot 'datos\ventasTransformed.csv'
        'modeloVentas.xlsx' = Join-Path $projectRoot 'datos\modeloVentas.xlsx'
    }
    foreach ($file in @($pbix) + @($script:sources.Values)) {
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
            throw "Falta el archivo: $file. Extrae todo el ZIP antes de ejecutar el BAT."
        }
    }
    if (-not [Environment]::Is64BitOperatingSystem) { throw 'Se requiere Windows de 64 bits y Power BI Desktop.' }
    Write-Host 'TechCore: ajustando las rutas a esta carpeta.' -ForegroundColor Cyan
    $sourceDesign = Join-Path $root 'src\avance_04\Modelo'
    if (-not (Test-Path -LiteralPath (Join-Path $sourceDesign 'Model\database.json'))) {
        throw 'Falta src/avance_04/Modelo. Extrae el ZIP completo.'
    }
    $extracted = Join-Path $run 'Modelo'
    Copy-Item -LiteralPath $sourceDesign -Destination $extracted -Recurse
    # Raw guarda el modelo completo en Model/database.json.
    $modelFile = Join-Path $extracted 'Model\database.json'
    if (-not (Test-Path -LiteralPath $modelFile -PathType Leaf)) { throw 'No se obtuvo Model/database.json. La version de Power BI puede ser incompatible con pbi-tools.' }
    $model = [IO.File]::ReadAllText($modelFile) | ConvertFrom-Json
    $script:changes = New-Object 'System.Collections.Generic.List[object]'
    $script:missing = New-Object 'System.Collections.Generic.List[string]'
    Rewrite-ModelNode $model
    if ($script:missing.Count -gt 0) {
        $script:missing | Sort-Object -Unique | Set-Content -LiteralPath (Join-Path $run 'fuentes_faltantes.txt') -Encoding UTF8
        throw ('El modelo depende de archivos no incluidos: ' + (($script:missing | Sort-Object -Unique) -join '; ') + '. No se genero una plantilla incompleta.')
    }
    if ($script:changes.Count -eq 0) {
        throw 'No se detectaron rutas literales File.Contents en el modelo. Este formato necesita una adaptacion especifica; no se ha modificado el PBIX.'
    }
    [IO.File]::WriteAllText($modelFile, ($model | ConvertTo-Json -Depth 100), $utf8)
    $script:changes | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $run 'rutas_actualizadas.json') -Encoding UTF8
    $template = Join-Path $run ('TechCore_' + $Vista + '_Avance_4.pbit')
    Invoke-CoreCompile -Folder $extracted -Template $template
    if (-not (Test-Path -LiteralPath $template -PathType Leaf)) { throw 'No se genero la plantilla PBIT.' }
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    # Incorpora el informe PBIR con escritorio y diseño móvil nativo.
    $reportDefinition = Join-Path $root ('src\avance_04\PBIR_' + $Vista)
    if (-not (Test-Path -LiteralPath (Join-Path $reportDefinition 'pages\pages.json'))) {
        throw 'Falta src/avance_04/PBIR. Extrae el ZIP completo para incluir el diseño móvil.'
    }
    $editZip = [IO.Compression.ZipFile]::Open($template, [System.IO.Compression.ZipArchiveMode]::Update)
    try {
        foreach ($entry in @($editZip.Entries | Where-Object { $_.FullName -eq 'Report/Layout' -or $_.FullName.StartsWith('Report/definition/') })) {
            $entry.Delete()
        }
        $versionEntry = $editZip.GetEntry('Version')
        if ($null -ne $versionEntry) { $versionEntry.Delete() }
        $versionEntry = $editZip.CreateEntry('Version')
        $versionEncoding = New-Object System.Text.UnicodeEncoding($false, $false)
        $versionWriter = New-Object IO.StreamWriter($versionEntry.Open(), $versionEncoding)
        try { $versionWriter.Write('1.32') } finally { $versionWriter.Dispose() }
        foreach ($file in Get-ChildItem -LiteralPath $reportDefinition -File -Recurse) {
            $relative = $file.FullName.Substring($reportDefinition.Length + 1).Replace('\', '/')
            [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($editZip, $file.FullName, ('Report/definition/' + $relative))
        }
        # Layout dejó de ser un componente del paquete: el informe usa PBIR.
        $typesEntry = $editZip.GetEntry('[Content_Types].xml')
        $typesReader = New-Object IO.StreamReader($typesEntry.Open())
        try { [xml]$typesXml = $typesReader.ReadToEnd() } finally { $typesReader.Dispose() }
        foreach ($node in @($typesXml.DocumentElement.ChildNodes)) {
            if ($node.LocalName -eq 'Override' -and $node.GetAttribute('PartName') -eq '/Report/Layout') {
                [void]$typesXml.DocumentElement.RemoveChild($node)
            }
        }
        $typesEntry.Delete()
        $typesEntry = $editZip.CreateEntry('[Content_Types].xml')
        $typesWriter = New-Object IO.StreamWriter($typesEntry.Open(), $utf8)
        try { $typesWriter.Write($typesXml.OuterXml) } finally { $typesWriter.Dispose() }
    } finally { $editZip.Dispose() }
    $zip = [IO.Compression.ZipFile]::OpenRead($template)
    try {
        $entry = $zip.GetEntry('DataModelSchema')
        if ($null -eq $entry) { throw 'La plantilla no contiene DataModelSchema.' }
        $stream = $entry.Open()
        $reader = New-Object IO.StreamReader($stream, [Text.Encoding]::Unicode, $true)
        try { $schema = $reader.ReadToEnd() | ConvertFrom-Json } finally { $reader.Dispose() }
        # Evita anunciar exito si el compilador no incorporo las rutas nuevas.
        $schemaText = $schema | ConvertTo-Json -Depth 100
        foreach ($change in $script:changes) {
            $escaped = $change.Despues.Replace('#(', '#(#)(').Replace('"', '""')
            $jsonPath = ConvertTo-Json -InputObject $escaped -Compress
            $needle = $jsonPath.Substring(1, $jsonPath.Length - 2)
            if (-not $schemaText.Contains($needle)) { throw 'No se pudo verificar una ruta en la plantilla compilada.' }
        }
    } finally { $zip.Dispose() }
    Write-Host ("Rutas preparadas: {0}." -f $script:changes.Count) -ForegroundColor Green
    Write-Host "Plantilla: $template"
    Write-Host 'Power BI cargara los datos al abrir la plantilla. Acepta los permisos de origen si los solicita.'
    Write-Host 'Incluye escritorio y movil: revisa Vista > Diseno movil en Power BI.'
    Write-Host 'Al terminar, guarda el nuevo informe como TechCore_Avance_4.pbix.'
    Write-Host 'Si mueves la carpeta, vuelve a ejecutar el BAT.'
    $destination = Join-Path $root ('dashboards\avance_04\' + $Vista.ToLowerInvariant() + '\TechCore_' + $Vista + '_Avance_4.pbit')
    Copy-Item -LiteralPath $template -Destination $destination -Force
    Write-Host ('Plantilla lista: ' + $destination) -ForegroundColor Green
    if (-not $NoAbrir) { Start-Process -FilePath $destination -WindowStyle Hidden }
    exit 0
} catch {
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    Write-Host 'Los archivos originales se conservan. Revisa .local/generado para ver el registro.'
    exit 1
} finally {
    if ($logStarted) { Stop-Transcript | Out-Null }
}
