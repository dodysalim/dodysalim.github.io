[CmdletBinding()]
param([switch]$Regenerar,[switch]$NoAbrir)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$template = Join-Path $repo 'dashboards\avance_04\movil\TechCore_Movil_Avance_4.pbit'
$local = Join-Path $repo '.local'
$manifest = Join-Path $local 'ubicacion_Movil.json'
$needsBuild = $Regenerar -or -not (Test-Path -LiteralPath $template) -or -not (Test-Path -LiteralPath $manifest)
if (-not $needsBuild) {
    $location = Get-Content -LiteralPath $manifest -Raw -Encoding UTF8 | ConvertFrom-Json
    $needsBuild = $location.Raiz -ne $repo
}
if ($needsBuild) {
    & powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo 'scripts\Preparar_TechCore.ps1') -Vista 'Movil' -NoAbrir
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    [void](New-Item -ItemType Directory -Path $local -Force)
    @{Raiz=$repo} | ConvertTo-Json | Set-Content -LiteralPath $manifest -Encoding UTF8
}
Write-Host 'TechCore Movil / Avance 4' -ForegroundColor Cyan
Write-Host $template
if (-not $NoAbrir) {
    try { Start-Process -FilePath $template -WindowStyle Hidden }
    catch { Write-Error 'Instala Power BI Desktop y asocia los archivos .pbit para abrir la plantilla.'; exit 1 }
}
exit 0
