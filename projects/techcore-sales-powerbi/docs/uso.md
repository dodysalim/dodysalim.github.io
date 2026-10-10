# Uso de los dashboards

## Escritorio

Abre la versión Escritorio, selecciona una página en la barra lateral y ajusta sus filtros. Los indicadores y gráficos responden al contexto de filtro de Power BI. Seleccionar una barra o una categoría permite explorar las interacciones configuradas en el informe; deselecciona el elemento para quitar esa selección.

La portada presenta TechCore y el alcance del proyecto. Resumen reúne los indicadores generales. Geografía, Productos, Clientes, Vendedores y Pagos desarrollan las dimensiones del negocio. Tiempo contiene comparaciones temporales y Cruces combina segmentos. Conclusiones conserva los hallazgos y recomendaciones del caso.

## Móvil

La versión Movil es una plantilla independiente con páginas verticales que también pueden verse en Power BI Desktop. En el PC se abre en **Tamaño real (100 %)** para evitar que el lienzo estrecho se amplíe hasta ocupar todo el ancho de la ventana. Puedes ajustar la vista desde Power BI si prefieres otra escala; el diseño móvil nativo para el teléfono se conserva. Conserva el diseño móvil nativo, igual que la versión Escritorio. La disposición usa un lienzo móvil de 323 unidades, márgenes de 12, separación vertical de 14 y tarjetas de ancho completo. Las tablas reciben más altura para facilitar su consulta.

En Desktop, usa el selector de diseño o **Vista > Diseño móvil** para revisar la disposición nativa. Los BAT preparan los archivos en Windows; la consulta en el teléfono se realiza en Power BI Mobile.

## Publicación en Power BI

1. Abre la plantilla con su iniciador y espera la actualización.
2. Guarda el PBIX con el nombre de la vista correspondiente.
3. Publica el PBIX desde Power BI Desktop en un espacio de trabajo al que tengas acceso.
4. Configura el acceso y los roles del informe en el servicio.
5. En el teléfono, inicia sesión en Power BI Mobile con una cuenta autorizada y abre el informe en vertical.

Las fuentes actuales son archivos locales. Para automatizar la actualización en el servicio tendrás que proporcionar una configuración de acceso adecuada a esas fuentes, por ejemplo una puerta de enlace configurada por tu organización. Los iniciadores no publican informes ni configuran credenciales o roles.

## Lectura de los indicadores

VentasTotales suma `DetalleFacturas[Subtotal]`; no debe confundirse con sumar directamente `Facturas[TotalVenta]`. Las medidas de costo y margen rotuladas como simuladas conservan los supuestos del caso académico. Las comparaciones con el año o mes anterior dependen del contexto de fechas y de la disponibilidad de datos de ambos períodos.

Consulta el [catálogo DAX](medidas-dax.md) para conocer las expresiones exactas y la [arquitectura](arquitectura.md) para revisar la propagación de filtros y los roles.

Referencias oficiales:
- [Diseño móvil en Power BI](https://learn.microsoft.com/en-us/power-bi/create-reports/power-bi-create-mobile-optimized-report-mobile-layout-view)
- [Publicar desde Power BI Desktop](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-upload-desktop-files)
