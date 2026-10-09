@echo off
setlocal DisableDelayedExpansion
title TechCore - Preparar rutas y abrir dashboard
cd /d "%~dp0"
if not exist "%~dp0Actualizar_Rutas_TechCore.ps1" (
  echo Falta Actualizar_Rutas_TechCore.ps1. Extrae el ZIP completo.
  pause
  exit /b 1
)
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Actualizar_Rutas_TechCore.ps1"
set "TECHCORE_RESULT=%ERRORLEVEL%"
echo.
if not "%TECHCORE_RESULT%"=="0" echo No se completo la preparacion. Revisa el mensaje y el registro.
pause
exit /b %TECHCORE_RESULT%
