# Windows PowerShell 5.1. No necesita permisos de administrador.
[CmdletBinding()]
param([switch]$NoAbrir)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)
$logStarted = $false

function Invoke-PbiTools {
    param([string[]]$ToolArguments)
    & $script:tool @ToolArguments
    if ($LASTEXITCODE -ne 0) {
        throw "pbi-tools termino con codigo $LASTEXITCODE. Consulta el registro."
    }
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
    $outputRoot = Join-Path $root 'Generado'
    [void](New-Item -ItemType Directory -Path $outputRoot -Force)
    $run = Join-Path $outputRoot ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,6))
    [void](New-Item -ItemType Directory -Path $run)
    Start-Transcript -Path (Join-Path $run 'ejecucion.log') | Out-Null
    $logStarted = $true
    $pbix = Join-Path $root 'Avances\Avance_3\Avance_3_Dashboard_PowerBI.pbix'
    $script:sources = @{
        'ventas.csv' = Join-Path $root 'Avances\Avance_1\ventas.csv'
        'ventasTransformed.csv' = Join-Path $root 'Avances\Avance_1\ventasTransformed.csv'
        'modeloVentas.xlsx' = Join-Path $root 'Avances\Avance_2\modeloVentas.xlsx'
    }
    foreach ($file in @($pbix) + @($script:sources.Values)) {
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
            throw "Falta el archivo: $file. Extrae todo el ZIP antes de ejecutar el BAT."
        }
    }
    if (-not [Environment]::Is64BitOperatingSystem) { throw 'Se requiere Windows de 64 bits y Power BI Desktop.' }
    Write-Host 'TechCore: ajustando las rutas a esta carpeta.' -ForegroundColor Cyan
    $cache = Join-Path $env:LOCALAPPDATA 'TechCore\pbi-tools-1.2.0'
    $script:tool = Join-Path $cache 'pbi-tools.exe'
    if (-not (Test-Path -LiteralPath $script:tool -PathType Leaf)) {
        [void](New-Item -ItemType Directory -Path $cache -Force)
        $download = Join-Path $run 'pbi-tools-1.2.0.zip'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Write-Host 'Descargando pbi-tools 1.2.0 desde su repositorio oficial (solo la primera vez)...'
        Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/pbi-tools/pbi-tools/releases/download/1.2.0/pbi-tools.1.2.0.zip' -OutFile $download
        Expand-Archive -LiteralPath $download -DestinationPath $cache -Force
        if (-not (Test-Path -LiteralPath $script:tool)) {
            $found = @(Get-ChildItem -LiteralPath $cache -Filter 'pbi-tools.exe' -Recurse -File)
            if ($found.Count -ne 1) { throw 'No se encontro pbi-tools.exe en la descarga.' }
            $script:tool = $found[0].FullName
        }
    }
    $extracted = Join-Path $run 'Modelo'
    Invoke-PbiTools -ToolArguments @('extract', $pbix, '-extractFolder', $extracted, '-modelSerialization', 'Raw', '-mashupSerialization', 'Raw')
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
    $template = Join-Path $run 'TechCore_Rutas_Actualizadas.pbit'
    Invoke-PbiTools -ToolArguments @('compile', $extracted, '-outPath', $template, '-format', 'PBIT')
    if (-not (Test-Path -LiteralPath $template -PathType Leaf)) { throw 'No se genero la plantilla PBIT.' }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
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
    Write-Host 'Al terminar, guarda el nuevo informe como TechCore_Actualizado.pbix.'
    Write-Host 'Si mueves la carpeta, vuelve a ejecutar el BAT.'
    if (-not $NoAbrir) { Start-Process -FilePath $template }
    exit 0
} catch {
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    Write-Host 'Los archivos originales se conservan. Revisa Generado para ver el registro.'
    exit 1
} finally {
    if ($logStarted) { Stop-Transcript | Out-Null }
}
