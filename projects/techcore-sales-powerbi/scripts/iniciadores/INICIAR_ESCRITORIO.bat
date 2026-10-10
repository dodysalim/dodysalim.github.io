@echo off
setlocal DisableDelayedExpansion
title TechCore Escritorio - Avance 4
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Iniciar_Escritorio.ps1" %*
set "TECHCORE_RESULT=%ERRORLEVEL%"
if not "%TECHCORE_RESULT%"=="0" (
 echo No se pudo iniciar TechCore. Revisa el mensaje anterior.
 pause
)
exit /b %TECHCORE_RESULT%
