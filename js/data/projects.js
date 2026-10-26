/**
 * Contenido del portafolio: fichas de proyectos, créditos de equipo y metadatos de presentación.
 * Solo datos: editar aquí no requiere tocar la lógica de la interfaz.
 */

export const projects = [
{"name": "ConversaAI", "label": "NO COUNTRY / S04-26 · EQUIPO 40", "category": "ml", "tags": ["Python", "NLP", "XLM-R", "Streamlit"], "description": "Análisis de sentimiento, intención y señales de abandono en conversaciones de soporte en español y portugués.", "problem": "Transformar mensajes de soporte en información para identificar necesidades del cliente y priorizar conversaciones.", "approach": "Pipeline NLP con XLM-R para tres clases de sentimiento y nueve intenciones, scoring heurístico de churn y alternativa de demostración offline.", "evidence": ["Código del pipeline y notebooks de entrenamiento publicados.", "Corpus de demostración bilingüe y dashboard Streamlit.", "Proyecto colectivo de Rosa Isela González Díaz, Jefferson Mangier, Dody Dueñas Remache y Geyson David."], "note": "Simulación laboral No Country. El riesgo de churn es un score heurístico, no una probabilidad calibrada. Los modelos y las métricas del equipo no se reentrenaron en esta incorporación.", "url": "ConversaAI-NLP-Support-Analytics", "cover": "assets/conversaai-cover.svg"},
{name:'TechCore · Ventas',label:'HENRY / MÓDULO 3',category:'bi',tags:['Power BI','DAX','Python'],description:'De ventas sin transformar a un modelo relacional y un informe de negocio.',problem:'Analizar ventas por producto, cliente, vendedor y sucursal manteniendo el contexto de filtros.',approach:'Limpieza con Power Query, modelado en Python y dashboard Power BI con seguridad por roles documentada.',evidence:['Caso académico documentado en el portafolio.','Preguntas de ventas y estructura del análisis.','Los archivos originales PBIX y del modelo están pendientes de incorporar al repositorio.'],note:'Proyecto académico. El costo del 65 % y el margen del 35 % se documentan como supuestos simulados, no como rentabilidad observada.',url:'@techcore'},
{name:'Bank Transactions',label:'PERSONAL / POWER BI',category:'bi',tags:['Power BI','Power Query','DAX'],description:'Más de un millón de registros organizados por fecha, sector y ubicación.',problem:'Distinguir cantidad de registros, transacciones y valor para comparar sectores y ubicaciones.',approach:'Vista web de agregados por mes, sector y ubicación. Incluye validación del archivo de agregados publicado.',evidence:['1.004.480 registros representados en los agregados.','Archivo bank-data.json disponible.','Filtros y tabla mensual con valores exactos.','Los archivos PBIP originales están pendientes de incorporar al repositorio.'],note:'Moneda y origen institucional no especificados. Las cifras son agregados del dataset proporcionado.',url:'@bank'},
{name:'Churn Intelligence',label:'NO COUNTRY / EQUIPO 40',category:'ml',tags:['XGBoost','Streamlit','Supabase'],description:'Análisis y predicción del abandono de clientes en comercio electrónico.',problem:'Identificar clientes con riesgo de abandono a partir de su comportamiento de compra.',approach:'El repositorio documenta segmentación RFM, etiquetado de churn, modelos y un dashboard.',evidence:['Notebooks de exploración, ingeniería de características y modelado.','Pipelines de entrenamiento e inferencia.','Pruebas unitarias y documentación de métricas.'],note:'Proyecto en equipo; repositorio derivado mediante fork. Las métricas del README no se han reentrenado en esta revisión.',url:'-E-commerce-Churn-Model-S03-26-Equipo-40-Data-Science'},
{name:'EquineLead',label:'NO COUNTRY / EQUIPO 45',category:'ml',tags:['Python','XGBoost','Streamlit'],description:'Analítica y priorización de leads en el mercado ecuestre.',problem:'Explorar el comportamiento de visitantes y priorizar oportunidades comerciales.',approach:'Sistema en equipo con pipelines, modelos y dashboard. El README del equipo identifica a Dody como Data Analyst.',evidence:['Módulos de analítica de audiencia y conversión.','Documentación del pipeline y de las fuentes.','Autoría y roles del equipo publicados.'],note:'La arquitectura y los modelos pertenecen al proyecto colectivo. El rol individual documentado es Data Analyst.',url:'S02-26-E45-Data_Science_EquineLead'},
{name:'LatAm Insights',label:'NO COUNTRY / MERCADO LABORAL',category:'bi',tags:['Python','Streamlit','Supabase'],description:'Exploración del mercado laboral a partir de vacantes y habilidades.',problem:'Organizar información de ofertas para entender perfiles y habilidades demandados.',approach:'Extracción, procesamiento y visualización; el repositorio documenta spiders y conexiones a Supabase.',evidence:['Código Python del proyecto.','Documentación de ejecución y configuración.','Integración de análisis y visualización.'],note:'La ejecución de extracción depende del acceso a fuentes externas y de sus condiciones de uso.',url:'Proyecto-No-Country'},
{name:'FleetLogix',label:'HENRY / MÓDULO 2',category:'engineering',tags:['PostgreSQL','Snowflake','Python'],description:'Modelado y procesamiento de datos sintéticos para analítica logística.',problem:'Conectar datos operativos de rutas, vehículos y entregas con indicadores logísticos.',approach:'Generadores de datos, ETL, bases relacionales y consultas analíticas; componentes AWS descritos como simulación.',evidence:['Generadores por entidad de negocio.','Consultas SQL y scripts de exportación.','Documentación del modelo y los KPIs.'],note:'Proyecto de formación con datos sintéticos. No equivale a una implementación empresarial en operación.',url:'FleetLogix-Master'},
{name:'Cliente360',label:'HENRY / PROYECTO INTEGRADOR',category:'ml',tags:['pandas','scikit-learn','Python'],description:'Segmentación de clientes y análisis de oportunidades de mercado.',problem:'Relacionar características de clientes y contexto del mercado con decisiones de segmentación.',approach:'ETL, características, regresión, clustering y reportes de análisis.',evidence:['Notebooks por etapa del pipeline.','Tablas procesadas y comparación de modelos.','Figuras e informe ejecutivo publicados.'],note:'Proyecto académico; las recomendaciones representan análisis del dataset, no impacto comercial medido.',image:'https://raw.githubusercontent.com/dodysalim/Cliente360-Predictive-Insight/main/reports/figures/15_executive_dashboard.png',url:'Cliente360-Predictive-Insight'},
{name:'Riesgo crediticio',label:'HENRY / MÓDULO 5',category:'ml',tags:['Python','ML','MLOps'],description:'Pipeline de análisis y predicción de riesgo crediticio.',problem:'Estudiar características asociadas al incumplimiento y evaluar un modelo predictivo.',approach:'Exploración, preparación de características y evaluación según la documentación del proyecto M5.',evidence:['Repositorio del proyecto integrador.','Diccionario de datos y metodología documentada.','Secciones de evaluación y despliegue.'],note:'Proyecto de formación. La evaluación requiere revisar partición, fuga de información y reproducibilidad antes de un uso operativo.',url:'Proyecto_Integrador_M5'},
{name:'Analytics Toolkit',label:'PERSONAL / HERRAMIENTAS',category:'engineering',tags:['Python','SQL','Streamlit'],description:'Módulos de análisis, limpieza y visualización reutilizables.',problem:'Organizar tareas frecuentes de análisis de datos en componentes reutilizables.',approach:'Módulos de calidad, evaluación, series temporales y análisis estadístico, con dashboard en src/app.',evidence:['Código de módulos y patrones.','Notebooks de exploración y consultas SQL.','Aplicación Streamlit organizada por vistas.'],note:'La utilidad de cada módulo se evalúa con sus entradas y dependencias; no se afirma cobertura de pruebas global.',url:'data-science-analytics-toolkit'},
{name:'KrioMetrics',label:'PERSONAL / REFRIGERACIÓN',category:'bi',tags:['Python','SQLite','Streamlit'],description:'Analítica de propiedades y comparación de gases refrigerantes.',problem:'Explorar propiedades de refrigerantes mediante un pipeline y visualizaciones.',approach:'ETL, almacenamiento y dashboards descritos en el repositorio.',evidence:['Notebooks y código de análisis.','Datos y recursos de refrigerantes.','Workflows y pruebas publicados.'],note:'Proyecto analítico; los valores y modelos requieren consultar sus fuentes antes de aplicaciones de ingeniería.',url:'refrigerant-gas-dashboard'},
{name:'Simpson 1/3',label:'PERSONAL / EXCEL VBA',category:'engineering',tags:['Excel','VBA','Cálculo'],description:'Cálculo y visualización de integrales definidas con integración numérica.',problem:'Aproximar integrales y mostrar la curva y la tabla de evaluación.',approach:'Libro Excel con macros y código VBA publicado para el método de Simpson 1/3.',evidence:['Simpson_Pro.xlsm en el repositorio.','Código VBA separado.','Documentación del método y la interfaz.'],note:'Requiere Excel con macros y un número par de subintervalos. Este es el proyecto matemático localizado en GitHub.',url:'Simpson-13-Dashboard-Excel'}
,
{"name": "M4 · HealthPredict y FinanceGuard", "label": "HENRY / MÓDULO 4", "category": "ml", "tags": ["Python", "scikit-learn", "Stacking", "Power BI"], "description": "Dos trabajos del módulo: clasificación por paciente y predicción de abandono bancario.", "problem": "Evaluar clasificación con dos casos académicos: riesgo por paciente y abandono bancario.", "approach": "Join validado, imputación, escalado y One-Hot dentro del pipeline. Holdout por patient_id y regresión logística. EDA, regresión logística, boosting, stacking, segmentación y umbral por costos.", "evidence": ["HealthPredict: código portable, notebook guiado y seis pruebas aprobadas.", "FinanceGuard: 10.000 clientes, cuatro notebooks y Power BI."], "note": "Proyecto académico Henry M4. Los CSV originales no estaban en la carpeta localizada: no se publican AUC ni resultados clínicos. Las pruebas usan fixtures sintéticos identificados. Las métricas históricas pertenecen a los notebooks guardados; el stacking no se reentrenó en esta revisión. El ROI corresponde a escenarios, no a ingresos recuperados observados.", "url": "churn-prediction-financeguard", "components": [{"name": "HealthPredict", "url": "https://github.com/dodysalim/dodysalim.github.io/tree/main/projects/healthpredict"}, {"name": "FinanceGuard", "url": "https://github.com/dodysalim/churn-prediction-financeguard"}]}
];

// Showcases oficiales y atribución pública de los equipos de No Country
export const noCountryCredits = {
  "Proyecto-No-Country": {
    "showcase": "https://nocountry.tech/showcase/simulacion-laboral-noviembre-2025/equipo-27-datascience",
    "edition": "Noviembre 2025",
    "official": "Market Scraper",
    "team": [
      [
        "Juan",
        "Machine Learning Engineer"
      ],
      [
        "Rosa",
        "Data Scientist"
      ],
      [
        "Dody",
        "Data analyst"
      ]
    ]
  },
  "S02-26-E45-Data_Science_EquineLead": {
    "showcase": "https://nocountry.tech/showcase/simulacion-laboral-febrero-2026/equipo-45-data-science",
    "edition": "Febrero 2026",
    "official": "EquineLead",
    "team": [
      [
        "Alexander Rios",
        "Data Scientist & ML Engineer"
      ],
      [
        "Daisy Quinteros",
        "Data Engineer & Data Scientist"
      ],
      [
        "Iñaki Rosello",
        "Data Scientist & ML Engineer"
      ],
      [
        "Dody Dueñas",
        "Data Analyst"
      ]
    ]
  },
  "-E-commerce-Churn-Model-S03-26-Equipo-40-Data-Science": {
    "showcase": "https://nocountry.tech/showcase/simulacion-laboral-marzo-2026/equipo-40-data-science",
    "edition": "Marzo 2026",
    "official": "E-commerce Churn Model",
    "team": [
      [
        "Lucel",
        "Data"
      ],
      [
        "Junior Alexis",
        "Data Scientist"
      ],
      [
        "Geyson David",
        "Data Scientist"
      ],
      [
        "Dody",
        "Data analyst"
      ]
    ]
  },
  "ConversaAI-NLP-Support-Analytics": {
    "showcase": "https://nocountry.tech/showcase/simulacion-laboral-abril-2026/equipo-40-data-science",
    "edition": "Abril 2026",
    "official": "ConversaAI",
    "team": [
      [
        "Jefferson Mangier",
        "Data Scientist"
      ],
      [
        "Rosa Isela González Díaz",
        "Data Scientist"
      ],
      [
        "Dody Dueñas Remache",
        "Data Scientist"
      ],
      [
        "Geyson David",
        "Data analyst"
      ]
    ]
  }
};

// Portada ilustrada y orden dentro de su grupo
export const projectPresentation = {"FleetLogix-Master":["fleetlogix",1],"@techcore":["techcore",2],"churn-prediction-financeguard":["m4",3],"Cliente360-Predictive-Insight":["cliente360",4],"Proyecto_Integrador_M5":["credit",5],"Proyecto-No-Country":["market",1],"S02-26-E45-Data_Science_EquineLead":["equinelead",2],"-E-commerce-Churn-Model-S03-26-Equipo-40-Data-Science":["churn",3],"ConversaAI-NLP-Support-Analytics":["conversaai",4],"@bank":["bank",4],"data-science-analytics-toolkit":["toolkit",3],"refrigerant-gas-dashboard":["kriometrics",2],"Simpson-13-Dashboard-Excel":["simpson",1]};

// Repositorios con carpeta Power BI para PC y móvil
export const powerbiRepos = new Set(["Proyecto_Integrador_M5", "refrigerant-gas-dashboard", "FleetLogix-Master", "Cliente360-Predictive-Insight", "-E-commerce-Churn-Model-S03-26-Equipo-40-Data-Science", "churn-prediction-financeguard", "Proyecto-No-Country", "data-science-analytics-toolkit", "S02-26-E45-Data_Science_EquineLead"]);

// Insignia de verificación por proyecto
export const reviewStatus = {'refrigerant-gas-dashboard':'59 pruebas · 5 vistas','Cliente360-Predictive-Insight':'7 pruebas · CI','FleetLogix-Master':'8 pruebas · PostgreSQL verificado','Proyecto_Integrador_M5':'26 pruebas · dashboard','-E-commerce-Churn-Model-S03-26-Equipo-40-Data-Science':'25 pruebas · modo demo','data-science-analytics-toolkit':'9 pruebas · 7 vistas','Proyecto-No-Country':'27 pruebas · SOLID','ConversaAI-NLP-Support-Analytics':'12 pruebas · offline','@health':'6 pruebas · M4'};
