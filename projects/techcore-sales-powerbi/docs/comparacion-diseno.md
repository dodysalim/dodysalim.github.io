# Comparación de diseño · Avance 3 y Avance 4

Esta revisión utiliza [capturas reales](../comparacion/README.md) del dashboard histórico y de las dos vistas nuevas. La [galería](../comparacion/galeria.html) permite comparar las mismas diez páginas. El histórico conserva su documentación y sus archivos.

## Qué cambia para quien utiliza el informe

| Aspecto | Avance 3 · Original | Avance 4 · Escritorio | Avance 4 · Móvil |
| --- | --- | --- | --- |
| Composición | Lienzo horizontal, títulos grandes y gráficos sobre blanco | Lienzo 1600 × 1000 con secciones y contenedores | Lienzo de 323 px de ancho; altura según contenido |
| Jerarquía | Título e indicadores con menor separación visual | Título, contexto, tarjetas KPI y zona de análisis | Lectura secuencial: encabezado, KPI, filtros y gráficos |
| Navegación | Navegador horizontal dentro del informe y pestañas | Navegación lateral con páginas abreviadas | Accesos en Inicio y pestañas de página en la previsualización |
| Indicadores | Valores y etiquetas sobre el fondo del informe | Tarjetas claras y valores destacados en turquesa | Tarjetas de ancho completo apiladas |
| Identidad | Logotipo en la portada | Logotipo original en las diez páginas | Logotipo original en las diez páginas |
| Color | Gráficos de tonos neutros | Azul oscuro y turquesa en títulos, navegación e indicadores | Misma identidad cromática que escritorio |
| Gráficos | Distribución horizontal original | Contenedores y espaciado reorganizados | Gráficos y tablas en una columna con desplazamiento vertical |
| Apertura | Vista del informe histórico | Ajustar a página | Tamaño real al 100 % para evitar ampliar el lienzo al ancho del PC |
| Entrega | PBIX y documentación histórica | PBIT, PBIR editable, BAT y PS1 propios | PBIT, PBIR editable, BAT y PS1 propios |

La paleta neutra de los gráficos originales se conserva: los acentos nuevos se concentran en los indicadores y la interfaz. En escritorio se puede recorrer una página completa; en móvil se prioriza el ancho legible y se recorre el contenido verticalmente.

## Ejemplo: desempeño de vendedores

![Vendedores · original](../comparacion/capturas/original/06-vendedores.png)

![Vendedores · escritorio](../comparacion/capturas/escritorio/06-vendedores.png)

![Vendedores · móvil al 100 %](../comparacion/capturas/movil/06-vendedores.png)

Las imágenes muestran el mismo contexto de datos. En escritorio, las tarjetas separan los indicadores del análisis; en móvil, cada indicador ocupa una fila y los gráficos se ubican debajo. Las capturas completas móviles sirven para revisar el orden de los bloques, aunque su texto resulta pequeño al reducir toda una página larga.

## Modelo y trazabilidad

Se mantienen 11 tablas, 8 relaciones, 26 medidas DAX y 3 roles RLS. La renovación visual no demuestra por sí misma una mejora de rendimiento, rentabilidad o decisiones empresariales: no se realizó una medición de esos efectos. Los datos son ficticios y el margen simulado conserva los supuestos del caso académico.

Para capturar las vistas nuevas se combinaron, en copias temporales, el `DataModel` del PBIX histórico y las definiciones nativas PBIR de cada plantilla. La [procedencia](../comparacion/procedencia.json) registra el hash del modelo para comprobar que las tres vistas utilizan la misma instantánea. Las capturas no equivalen a una actualización de las fuentes Excel/CSV.

## Condiciones de visualización

- Son capturas de Power BI Desktop en una pantalla de 1366 × 768; incluyen la interfaz de edición.
- Móvil se capturó como previsualización en el PC. Su uso en un teléfono todavía requiere publicar y revisar el informe en Power BI Mobile.
- Escritorio se ajusta a la ventana. Con una escala reducida, algunos valores extensos pueden aparecer abreviados o truncados; ampliar el informe permite examinarlos.
- Las vistas móviles iniciales muestran el comienzo de cada página al 100 %. Las imágenes `-vista-completa` reducen el lienzo para documentar todo su contenido.
- Azure Maps solicita autenticación en este equipo. Se conserva el aviso del visual y se omiten las ventanas modales de autenticación; no se certifica aquí el mapa autenticado.
- No se verificó el comportamiento de los tres roles RLS en una sesión publicada.

Microsoft documenta el [diseño móvil](https://learn.microsoft.com/en-us/power-bi/create-reports/power-bi-create-mobile-optimized-report-mobile-layout-view) y el [formato de proyecto de informes](https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-report). Para el uso y la publicación del proyecto, consulta [uso.md](uso.md).

## Documento de presentación

El [PDF TechCore · Evolución del dashboard](presentacion/TechCore_Evolucion_Dashboard.pdf) resume el proyecto y sus cambios visuales en ocho páginas, con capturas reales del original, escritorio y previsualización móvil.

Las [láminas individuales](presentacion/README.md) se conservan en `docs/presentacion/laminas`.
