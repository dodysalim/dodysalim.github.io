# Subir el proyecto a GitHub

Usa **TechCore_GitHub** como raíz del repositorio. No subas la carpeta de trabajo anterior además de esta: los avances y documentos anteriores ya están en `historico`.

Por la cantidad de archivos PBIR y fuentes históricas, se recomienda subir este proyecto con **Git** usando los comandos de la sección correspondiente.

## Desde la web

1. Crea un repositorio vacío en tu cuenta de GitHub, por ejemplo `techcore-powerbi`.
2. Selecciona **Add file > Upload files**. GitHub permite cargar hasta 100 archivos a la vez desde la web; divide la carga en lotes conservando las rutas, o usa Git para subir el proyecto completo.
3. Incluye `README.md`, las carpetas del proyecto y los archivos ocultos `.gitignore` y `.gitattributes`. Si Windows oculta esos archivos, habilita su visualización o añádelos con Git.
4. Guarda la carga con un mensaje descriptivo, por ejemplo `Organiza TechCore y documenta el Avance 4`.
5. Revisa que el README aparezca con el logotipo y que sus enlaces relativos funcionen.

GitHub no aplica `.gitignore` cuando seleccionas archivos manualmente en su interfaz. Excluye `.local`, registros, temporales y ZIP. El ZIP de distribución debe extraerse antes de subir su contenido; no reemplaza los archivos de un repositorio.

## Desde Git en PowerShell

Abre PowerShell en `TechCore_GitHub`. Sustituye `TU_USUARIO` y el nombre del repositorio por los tuyos:

```powershell
git init
git branch -M main
git add .
git status --short
git commit -m "Organiza TechCore y documenta el Avance 4"
git remote add origin https://github.com/TU_USUARIO/techcore-powerbi.git
git push -u origin main
```

La URL anterior es un ejemplo que debes sustituir. Esta entrega prepara los archivos locales; no crea un repositorio remoto ni publica en tu cuenta.

## Qué se versiona

Incluye las plantillas PBIT actuales, el código PBIR y del modelo, datos del caso, scripts, documentación, el logo y las entregas históricas. `.gitignore` omite `.local`, cachés, registros, ZIP e informes PBIX personales, y conserva expresamente los PBIX originales de los avances 1 y 3.

`.gitattributes` marca como binarios los archivos PBIX, PBIT, Excel, imágenes y PDF. Conserva los CSV tal como fueron recibidos para no alterar su codificación. Para los scripts de Windows define finales de línea CRLF.

## Descripción sugerida del repositorio

> Proyecto académico de análisis de ventas TechCore con Power BI: limpieza, modelado relacional, 26 medidas DAX y dashboards de escritorio y móvil.

Temas sugeridos: `powerbi`, `business-intelligence`, `data-analysis`, `dax`, `python`, `dashboard`.

La entrega no añade una licencia nueva ni modifica los avisos históricos. Si deseas autorizar la reutilización pública del código, elige una licencia acorde con los derechos del proyecto y de sus recursos.

Referencias oficiales: [Cargar archivos en GitHub](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository) y [archivos ignorados por Git](https://docs.github.com/en/get-started/git-basics/ignoring-files).
