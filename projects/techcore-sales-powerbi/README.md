# TechCore · Análisis de ventas con Power BI

Proyecto integrador del módulo 3 de Henry, desarrollado por Dody Salim Dueñas Remache. Reúne la limpieza de ventas, el modelado relacional en Python y el dashboard final de Power BI.

## Archivos del proyecto

| Etapa | Entregable |
| --- | --- |
| Datos de origen | [ventas.csv](Avances/Avance_1/ventas.csv) |
| Datos transformados | [ventasTransformed.csv](Avances/Avance_1/ventasTransformed.csv) |
| Limpieza y transformación | [Power BI del avance 1](Avances/Avance_1/Avance_1_Limpieza_Transformacion.pbix) |
| Modelado relacional | [Notebook del avance 2](Avances/Avance_2/Avance_2_Modelo_Relacional.ipynb) |
| Modelo para Power BI | [modeloVentas.xlsx](Avances/Avance_2/modeloVentas.xlsx) |
| Dashboard final | [Power BI del avance 3](Avances/Avance_3/Avance_3_Dashboard_PowerBI.pbix) |
| Documentación técnica | [README original](Documentacion/README.md) · [PDF](Documentacion/README.pdf) |
| Conclusiones | [Conclusiones y recomendaciones](Documentacion/Conclusiones_Recomendaciones.pdf) |

## Qué incluye

El dashboard final contiene diez páginas, desde la portada y el resumen ejecutivo hasta los análisis geográfico, de productos, clientes, vendedores, tiempo, métodos de pago, análisis cruzado y conclusiones. El modelo organiza facturas y detalles de venta junto con clientes, productos, vendedores, sucursales, ciudades y métodos de pago. La documentación explica las medidas DAX, los filtros, la inteligencia de tiempo y la configuración de seguridad por roles.

**Tecnologías:** Power BI, Power Query, DAX, Python, pandas y Excel.

## Inicio con rutas automáticas

Ejecuta [INICIAR_TECHCORE.bat](INICIAR_TECHCORE.bat) después de descargar y extraer toda esta carpeta. El BAT llama al script PowerShell incluido, adapta las fuentes locales y genera una plantilla PBIT que Power BI puede abrir y cargar. Guarda el resultado como un nuevo PBIX. Consulta [las instrucciones y límites](LEEME_INICIO.md). Requiere Windows, Power BI Desktop y conexión para descargar pbi-tools y preparar .NET 8 en el primer uso. La compilación usa pbi-tools Core para evitar la incompatibilidad del empaquetador con Power BI Desktop 2.158. Esta automatización está preparada; su ejecución completa necesita validación en Windows.

Los datos de clientes son ficticios, según la confirmación del autor.

## Cómo abrirlo

1. Descarga esta carpeta o el repositorio completo.
2. Abre `Avances/Avance_3/Avance_3_Dashboard_PowerBI.pbix` en Power BI Desktop.
3. Para actualizar los datos, ajusta las rutas de origen en Power Query a la ubicación local del Excel y los CSV descargados.
4. Para revisar el proceso de modelado, abre el notebook con Jupyter y ajusta la ruta de entrada al CSV de este proyecto.

Los entregables originales se conservan con su estructura por avances. Los archivos PBIX requieren Power BI Desktop; la comprobación de integridad de los archivos no sustituye una prueba de actualización en esa aplicación. El costo y el margen identificados como simulados en la documentación son supuestos analíticos.

[Ver portafolio](https://dodysalim.github.io/)
