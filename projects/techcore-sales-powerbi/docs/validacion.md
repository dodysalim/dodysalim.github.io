# Validación y mantenimiento

## Preparar las plantillas

Desde PowerShell en la raíz:

```powershell
.\scripts\iniciadores\INICIAR_ESCRITORIO.bat -Regenerar -NoAbrir
.\scripts\iniciadores\INICIAR_MOVIL.bat -Regenerar -NoAbrir
```

Los comandos prueban la preparación local sin lanzar Power BI. `-Regenerar` incorpora las modificaciones de `src/avance_04`. El modelo original se copia antes de adaptar las rutas; el archivo fuente permanece intacto.

## Ejecutar la validación

El verificador usa Python y `jsonschema`. Si no lo tienes instalado:

```powershell
python -m pip install jsonschema
python .\scripts\verificacion\Verificar_Entrega.py
```

Se incluyen los esquemas utilizados por la entrega. Si hace falta uno adicional, el script lo descarga del dominio oficial de Microsoft y lo guarda en `scripts/verificacion/esquemas`.

El verificador comprueba:

- Definiciones PBIR contra los esquemas oficiales.
- Diez páginas por vista y posiciones dentro del lienzo.
- Disposición móvil sin solapamientos y logotipo en todas las páginas.
- Consultas y filtros originales conservados.
- Coincidencia entre fuentes PBIR y contenido de las plantillas.
- Presencia de los recursos estáticos, incluido el logotipo.
- Columnas, medidas, relaciones y roles conservados.
- Integridad de los archivos históricos mediante SHA-256.

Escribe el resultado en `docs/validacion/avance_04.json` y devuelve un código distinto de cero si una comprobación falla. El informe anterior se conserva como referencia en `avance_04-anterior.json`.

## Cambiar el diseño

Edita `src/avance_04/PBIR_Escritorio` o `PBIR_Movil`. Cada página tiene `page.json` y cada visual tiene `visual.json`; los estados móviles están en `mobile.json`. Regenera la vista correspondiente y ejecuta la validación. Para cambiar el modelo, revisa `src/avance_04/Modelo/Model/database.json` y documenta las modificaciones de cálculos o relaciones.

Tras editar el modelo, el verificador de conservación exige actualizar deliberadamente la referencia histórica o ajustar las comprobaciones para esa nueva versión. No cambies el histórico para ocultar una diferencia.

## Comprobación nativa y tareas pendientes

La entrega incluye capturas nativas de las diez páginas del informe anterior y de ambas vistas nuevas, tomadas con la misma instantánea de datos del PBIX original. Consulta la [comparación](comparacion-diseno.md) y su [procedencia](../comparacion/procedencia.json).

La compilación y los esquemas no ejecutan Power BI. Siguen pendientes la actualización de las fuentes desde las plantillas, los mapas autenticados, los roles publicados y la comprobación en un teléfono. Las capturas del modelo almacenado no sustituyen esas pruebas.

## Capturas del informe

El script [Capturar_PowerBI.ps1](../scripts/capturas/Capturar_PowerBI.ps1) captura una ventana de trabajo abierta en Power BI Desktop. Requiere una sesión de Windows desbloqueada y permiso para interactuar con la pantalla. No utiliza credenciales ni publica el informe.

```powershell
.\scripts\capturas\Capturar_PowerBI.ps1 -PowerBiProcessId 12345 -Vista Movil
```

Sustituye `12345` por el PID de tu ventana de comparación. El título debe comenzar por `TechCore_`; admite `Original`, `Escritorio` o `Movil`, y los rangos `-Desde` / `-Hasta`. Navega páginas y ajusta la vista; trabaja con copias, evita guardar esas acciones en los archivos históricos o en las plantillas finales. Para móvil, abre una copia nueva con páginas en tamaño real antes de capturar: la vista completa se ajusta a página en memoria.
