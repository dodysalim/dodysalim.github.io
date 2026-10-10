# Instalación

## Requisitos

- Windows de 64 bits y PowerShell 5.1 o posterior.
- Power BI Desktop compatible con el formato PBIR utilizado por las plantillas.
- Conexión a Internet en la primera preparación si no están en caché pbi-tools Core 1.2.0 o el runtime .NET 8.
- El repositorio completo: `datos`, `src`, `scripts`, `dashboards` e `historico`.

La preparación usa herramientas locales del usuario; no requiere permisos de administrador. Las carpetas con espacios y caracteres como `ñ` se admiten.

## Abrir una vista

Ejecuta `scripts/iniciadores/INICIAR_ESCRITORIO.bat` o `scripts/iniciadores/INICIAR_MOVIL.bat`. Cada BAT invoca el PS1 de la misma carpeta y mantiene el código de salida del proceso.

El PS1 comprueba la ubicación del repositorio. Si la ubicación cambió, falta la plantilla o se pide una regeneración, llama a `scripts/Preparar_TechCore.ps1`. Este copia el modelo a `.local/generado`, adapta los `File.Contents` a `datos`, compila la plantilla y añade la definición PBIR correspondiente. Después abre el archivo PBIT.

En Power BI, autoriza el acceso a los archivos locales si se solicita, espera a que termine la carga y guarda el informe como `TechCore_Escritorio_Avance_4.pbix` o `TechCore_Movil_Avance_4.pbix`. Los PBIX personales se excluyen de Git; las entregas históricas se incluyen expresamente.

## Opciones de los iniciadores

Desde PowerShell, ubicado en la raíz del repositorio:

```powershell
# Preparar y abrir escritorio
.\scripts\iniciadores\INICIAR_ESCRITORIO.bat

# Forzar la regeneración y abrir móvil
.\scripts\iniciadores\INICIAR_MOVIL.bat -Regenerar

# Preparar sin abrir Power BI: útil para comprobar el script
.\scripts\iniciadores\INICIAR_ESCRITORIO.bat -NoAbrir
```

Para mover o compartir el proyecto, copia el repositorio completo. Al abrirlo en el nuevo equipo, los iniciadores vuelven a preparar las rutas. Las plantillas empaquetadas pueden contener rutas de la máquina que las generó; usa el BAT para adaptarlas.

## Solución de problemas

| Problema | Acción |
| --- | --- |
| El PBIT no abre | Instala Power BI Desktop y abre el archivo desde esa aplicación; revisa su asociación en Windows. |
| Falta un CSV, XLSX o archivo de diseño | Descarga y extrae el repositorio completo. |
| Falló la descarga de herramientas | Comprueba la conexión y el acceso a GitHub y `dot.net`; vuelve a ejecutar el BAT. |
| Los datos apuntan a otra carpeta | Ejecuta el BAT con `-Regenerar`. |
| El script termina con error | Revisa el mensaje y `.local/generado/<ejecucion>/ejecucion.log`. |
| El mapa no carga | Revisa la conexión y los permisos de mapas de Power BI. |
| Una organización bloquea los scripts | Usa la configuración permitida por tu organización o abre la plantilla manualmente y corrige los orígenes en Power BI. |

El uso de `ExecutionPolicy Bypass` en los BAT se limita al proceso lanzado; no modifica la política global del equipo.
