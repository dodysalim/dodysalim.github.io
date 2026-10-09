# Iniciar TechCore en otra computadora

1. Instala Power BI Desktop de 64 bits.
2. Descarga y extrae **todo** el proyecto. Conserva las carpetas `Avances` y `Documentacion` junto al BAT y el PS1.
3. Haz doble clic en `INICIAR_TECHCORE.bat`. No necesita ejecutarse como administrador.
4. El programa descarga pbi-tools 1.2.0 desde su repositorio oficial la primera vez, extrae el modelo del dashboard y sustituye las rutas literales de `ventas.csv`, `ventasTransformed.csv` y `modeloVentas.xlsx` por las de tu carpeta.
5. Genera y abre `Generado/<ejecucion>/TechCore_Rutas_Actualizadas.pbit`. Power BI carga los datos; acepta cualquier solicitud de permisos de origen.
6. Guarda el resultado como `TechCore_Actualizado.pbix`.

Cada ejecucion tiene su propia carpeta y registro. Si mueves el proyecto, vuelve a ejecutar el BAT. Los PBIX originales se conservan.

## Alcance y validacion

Se adapta el **dashboard final del avance 3**. El PBIX de limpieza del avance 1 y el notebook mantienen sus fuentes originales.

La plantilla conserva el modelo y el informe extraidos; necesita importar los datos de nuevo. El BAT no guarda automaticamente un nuevo PBIX ni garantiza que las consultas originales carezcan de otros errores. Si el modelo utiliza parametros de ruta, archivos adicionales o una version que pbi-tools no pueda extraer, se detiene y deja el detalle del error; no declara exito ni inventa fuentes.

Se revisaron los archivos originales y la logica de sustitucion. La ejecucion de pbi-tools y Power BI Desktop debe validarse en Windows: no se dispone de esas aplicaciones en el entorno de preparacion.

Documentacion de la herramienta: https://pbi.tools/cli/usage.html

## Correccion para Power BI Desktop 2.158 (septiembre 2026)

La compilacion utiliza pbi-tools **Core**, que evita el empaquetador de Power BI Desktop que provoco MissingMethodException. La extraccion sigue usando pbi-tools Desktop. La primera ejecucion descarga Core y prepara .NET 8 con el instalador oficial de Microsoft dentro de la carpeta del usuario; no necesita permisos de administrador.
