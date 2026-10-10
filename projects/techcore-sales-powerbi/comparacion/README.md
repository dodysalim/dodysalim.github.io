# Evolución visual de TechCore

Comparación entre **Avance_3_Dashboard_PowerBI.pbix**, **Avance 4 · Escritorio** y **Avance 4 · Móvil**. Las imágenes son capturas reales de Power BI Desktop. La vista móvil se documenta desde su previsualización en el PC; no corresponde a una captura de un teléfono.

Abre [galeria.html](galeria.html) en tu navegador después de descargar el proyecto: permite elegir las diez páginas, ampliar cada captura y alternar entre el inicio móvil al 100 % y su estructura completa ajustada a la página.

| Anterior · Vendedores | Nuevo escritorio · Vendedores |
| --- | --- |
| ![Anterior](capturas/original/06-vendedores.png) | ![Escritorio](capturas/escritorio/06-vendedores.png) |

![Vista móvil al 100 %](capturas/movil/06-vendedores.png)

Consulta el [análisis de diseño](../docs/comparacion-diseno.md) y la [procedencia técnica](procedencia.json).

## Organización

- `capturas/original`: diez páginas del PBIX del Avance 3.
- `capturas/escritorio`: diez páginas del Avance 4 para escritorio.
- `capturas/movil`: diez vistas iniciales al 100 % y diez vistas completas ajustadas a la página.
- Cada carpeta incluye su manifiesto de captura. La captura adicional de Resumen conserva el contexto de la ventana.
- `galeria.html`: comparación interactiva local, sin servicios externos.
- `procedencia.json`: hashes del PBIX original, del modelo utilizado y de las imágenes.

## Criterio de comparación

Los tres informes se abrieron con la misma instantánea del modelo de datos del PBIX original. Para las dos vistas nuevas se utilizaron copias temporales con las definiciones PBIR del Avance 4. Esto permite comparar el diseño sin atribuir diferencias a una actualización de datos. Las copias operativas quedan en `.local`, fuera del repositorio y del ZIP.

Los mapas de Azure Maps pueden mostrar el aviso de inicio de sesión. No se inició sesión para esta captura; ese aviso se conserva como una limitación del entorno. El archivo histórico y las plantillas finales no fueron reemplazados para obtener las imágenes.
