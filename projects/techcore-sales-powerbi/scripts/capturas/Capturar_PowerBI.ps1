[CmdletBinding()]
param([Parameter(Mandatory=$true)][int]$PowerBiProcessId,[Parameter(Mandatory=$true)][ValidateSet('Original','Escritorio','Movil')][string]$Vista,[int]$Desde=1,[int]$Hasta=10)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class TechCoreScreen {
 [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
 [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd,int n);
 [DllImport("user32.dll")] public static extern bool SetCursorPos(int x,int y);
 [DllImport("user32.dll")] public static extern void keybd_event(byte key,byte scan,uint flags,UIntPtr extra);
 [DllImport("user32.dll")] public static extern void mouse_event(uint flags,uint x,uint y,uint data,UIntPtr info);
}
"@
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$output = Join-Path $repo ('comparacion\capturas\' + $Vista.ToLowerInvariant())
[void](New-Item -ItemType Directory -Path $output -Force)
$condition = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ProcessIdProperty,$PowerBiProcessId)
$window = $null
for ($ready=0; $ready -lt 75; $ready++) {
 $windows = [System.Windows.Automation.AutomationElement]::RootElement.FindAll([System.Windows.Automation.TreeScope]::Children,$condition)
 foreach ($candidate in $windows) { if ($candidate.Current.Name.StartsWith('TechCore_') -and $candidate.Current.BoundingRectangle.Width -gt 500) { $window = $candidate; break } }
 if ($null -ne $window) { break }
 if ($ready % 15 -eq 0) { Write-Output ('Esperando que abra Power BI / ' + $Vista) }
 Start-Sleep -Seconds 1
}
if ($null -eq $window) { throw 'No se encontro la ventana TechCore de comparacion.' }
$handle = [IntPtr]$window.Current.NativeWindowHandle
[void][TechCoreScreen]::ShowWindow($handle,3)
[void][TechCoreScreen]::SetForegroundWindow($handle)
function Click-Point([double]$X,[double]$Y) {
 [void][TechCoreScreen]::SetCursorPos([int]$X,[int]$Y)
 [TechCoreScreen]::mouse_event(2,0,0,0,[UIntPtr]::Zero)
 [TechCoreScreen]::mouse_event(4,0,0,0,[UIntPtr]::Zero)
 Start-Sleep -Milliseconds 180
}
function Find-Named([string]$Name) {
 $c = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::NameProperty,$Name)
 return $window.FindAll([System.Windows.Automation.TreeScope]::Descendants,$c)
}
function Click-Element($Element,[switch]$RightEdge) {
 $r = $Element.Current.BoundingRectangle
 if ($r.IsEmpty -or $r.Width -lt 1) { throw 'Control sin coordenadas.' }
 $x = $r.X + $r.Width / 2
 if ($RightEdge) { $x = $r.Right - 8 }
 Click-Point $x ($r.Y + $r.Height / 2)
}
function Close-SignInDialog {
 $items=$window.FindAll([System.Windows.Automation.TreeScope]::Descendants,[System.Windows.Automation.Condition]::TrueCondition)
 $auth=$false
 foreach ($item in $items) { if ($item.Current.Name -match 'Escriba su direcci|^Correo electr') { $auth=$true; break } }
 if (-not $auth) { return $false }
 foreach ($element in (Find-Named 'Cancelar')) { $c=$element.Current; if (-not $c.IsOffscreen -and $c.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $c.BoundingRectangle.X -gt 300 -and $c.BoundingRectangle.Y -gt 200) { Click-Element $element; Start-Sleep -Seconds 1; return $true } }
 return $false
}
function Screenshot([string]$Path,$Rect) {
 $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
 $x = [Math]::Max(0,[int][Math]::Ceiling($Rect.X))
 $y = [Math]::Max(0,[int][Math]::Ceiling($Rect.Y))
 $right = [Math]::Min($screen.Right,[int][Math]::Floor($Rect.Right))
 $bottom = [Math]::Min($screen.Bottom,[int][Math]::Floor($Rect.Bottom))
 if ($right -le $x -or $bottom -le $y) { throw 'Area de captura no valida.' }
 $bitmap = New-Object System.Drawing.Bitmap(($right-$x),($bottom-$y))
 $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
 try { $graphics.CopyFromScreen($x,$y,0,0,$bitmap.Size); $bitmap.Save($Path,[System.Drawing.Imaging.ImageFormat]::Png) } finally { $graphics.Dispose(); $bitmap.Dispose() }
 return @{X=$x;Y=$y;Ancho=($right-$x);Alto=($bottom-$y)}
}
Click-Point 680 16
# Always switch to the report view using its visible left-hand icon.
foreach ($element in (Find-Named 'Vista de informe')) { $r=$element.Current.BoundingRectangle; if ($r.X -ge 0 -and $r.X -lt 40 -and $r.Width -gt 0) { Click-Element $element; break } }
Start-Sleep -Seconds 1
# Collapse only editing panes in this working copy.
foreach ($name in @('Visualizaciones','Explorador de formatos','Datos')) {
 foreach ($element in (Find-Named $name)) { $c=$element.Current; if (-not $c.IsOffscreen -and $c.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $c.BoundingRectangle.Y -lt 240 -and $c.BoundingRectangle.Width -gt 100) { Click-Element $element -RightEdge; break } }
}
foreach ($element in (Find-Named 'Contrae o expande el panel de filtrado al editar. Esto también determina el modo en que los lectores del informe lo verán.')) { if (-not $element.Current.IsOffscreen) { Click-Element $element; break } }
# Ribbon folding is presentation only; it does not edit the report.
foreach ($element in (Find-Named 'Cambiar cintas')) { if (-not $element.Current.IsOffscreen) { Click-Element $element; break } }
$labels = @('Portada','Resumen Ejecutivo','Análisis Geográfico','Análisis de Productos','Análisis de Clientes','Análisis de Vendedores','Análisis Temporal','Análisis de Métodos de Pago y Descuentos','Análisis Cruzado','Conclusiones')
$slugs = @('01-inicio','02-resumen','03-geografia','04-productos','05-clientes','06-vendedores','07-tiempo','08-pagos','09-cruces','10-conclusiones')
if ($Vista -ne 'Original') { $labels = @('Inicio','Resumen','Geografía','Productos','Clientes','Vendedores','Tiempo','Pagos','Cruces','Conclusiones') }
$records = New-Object 'System.Collections.Generic.List[object]'
for ($i=0; $i -lt $labels.Count; $i++) {
 if ($i+1 -lt $Desde -or $i+1 -gt $Hasta) { continue }
 [System.Windows.Forms.SendKeys]::SendWait('{ESC}')
 Start-Sleep -Milliseconds 400
 [void](Close-SignInDialog)
 $selected = $false
 # Page navigators require Ctrl+click in Power BI Desktop edit mode.
 foreach ($element in (Find-Named $labels[$i])) {
  $c=$element.Current; $r=$c.BoundingRectangle
  if ($Vista -ne 'Movil' -and $c.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $r.Y -gt 110 -and $r.Y -lt 655 -and $r.X -ge 40 -and $r.Right -lt 1290) {
   [TechCoreScreen]::keybd_event(17,0,0,[UIntPtr]::Zero)
   Click-Element $element
   [TechCoreScreen]::keybd_event(17,0,2,[UIntPtr]::Zero)
   $selected=$true; break
  }
 }
 if (-not $selected) {
  for ($attempt=0; $attempt -lt 30; $attempt++) {
   $tab=$null
   foreach ($element in (Find-Named $labels[$i])) { $c=$element.Current; if ($c.ControlType.ProgrammaticName -eq 'ControlType.TabItem' -and $c.BoundingRectangle.Y -gt 600) { $tab=$element; break } }
   if ($null -eq $tab) { throw ('No se encontro la pestana: ' + $labels[$i]) }
   $r=$tab.Current.BoundingRectangle
   if ($r.X -ge 160 -and $r.X -lt 1240) { Click-Point ([Math]::Min(1260,$r.X+$r.Width/2)) ($r.Y+$r.Height/2); $selected=$true; break }
   $arrow = 'Páginas siguientes'
   if ($r.X -lt 160) { $arrow='Páginas anteriores' }
   foreach ($element in (Find-Named $arrow)) { $c=$element.Current; if ($c.BoundingRectangle.Y -gt 600 -and $c.BoundingRectangle.X -lt 200 -and $c.BoundingRectangle.X -ge 0) { Click-Element $element; Start-Sleep -Milliseconds 450; break } }
  }
 }
 if (-not $selected) { throw ('No se pudo seleccionar: ' + $labels[$i]) }
 Start-Sleep -Seconds 6
 [System.Windows.Forms.SendKeys]::SendWait('{ESC}')
 Start-Sleep -Milliseconds 300
 if (Close-SignInDialog) {
  foreach ($element in (Find-Named $labels[$i])) { $c=$element.Current; $r=$c.BoundingRectangle; if ($c.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $r.Y -gt 110 -and $r.Y -lt 655 -and $r.X -ge 40 -and $r.Right -lt 1290) { [TechCoreScreen]::keybd_event(17,0,0,[UIntPtr]::Zero); Click-Element $element; [TechCoreScreen]::keybd_event(17,0,2,[UIntPtr]::Zero); break } }
  Start-Sleep -Seconds 6
  [void](Close-SignInDialog)
 }
 $expected='Página ' + ($i+1) + ' de 10'
 if ((Find-Named $expected).Count -eq 0) { Write-Output ('Verificar en captura: '+$labels[$i]) }
 # Full Power BI window preserves visible data and application context.
 $canvas=$window.Current.BoundingRectangle
 $path=Join-Path $output ($slugs[$i]+'.png')
 [void][TechCoreScreen]::SetCursorPos(680,16)
  Start-Sleep -Seconds 1
 $rect=Screenshot $path $canvas
 $records.Add(@{Vista=$Vista;Pagina=$labels[$i];Indice=($i+1);Archivo=('comparacion/capturas/'+$Vista.ToLowerInvariant()+'/'+$slugs[$i]+'.png');Region=$rect;Tipo='captura real de la ventana Power BI';Fecha=(Get-Date).ToString('o')})
 if ($i -eq 1) { [void](Screenshot (Join-Path $output '02-resumen-ventana.png') $window.Current.BoundingRectangle) }
 if ($Vista -eq 'Movil') {
  foreach ($element in (Find-Named 'Ajustar a la página')) { $c=$element.Current; if ($c.BoundingRectangle.X -gt 1300 -and $c.BoundingRectangle.Y -gt 690) { Click-Element $element; break } }
  Start-Sleep -Seconds 2
  $canvas=$window.Current.BoundingRectangle
  [void][TechCoreScreen]::SetCursorPos(680,16)
  Start-Sleep -Seconds 1
  $rect=Screenshot (Join-Path $output ($slugs[$i]+'-vista-completa.png')) $canvas
  $records.Add(@{Vista=$Vista;Pagina=$labels[$i];Indice=($i+1);Archivo=('comparacion/capturas/movil/'+$slugs[$i]+'-vista-completa.png');Region=$rect;Tipo='captura real ajustada a pagina para documentar la estructura';Fecha=(Get-Date).ToString('o')})
 }
 Write-Output ('CAPTURADA ' + $Vista + ' / ' + $labels[$i])
}
$manifest=Join-Path $output 'manifest.json'
if (Test-Path -LiteralPath $manifest) { $previous = Get-Content -LiteralPath $manifest -Raw -Encoding UTF8 | ConvertFrom-Json; foreach ($record in $previous) { if ($record.Indice -lt $Desde -or $record.Indice -gt $Hasta) { $records.Add($record) } } }
[IO.File]::WriteAllText($manifest,(($records | Sort-Object Indice,Archivo) | ConvertTo-Json -Depth 8),(New-Object System.Text.UTF8Encoding($false)))
Write-Output ('Capturas terminadas: ' + $manifest)