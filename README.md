# Portafolio · Dody Dueñas Remache

**Analista de Datos / Data Scientist junior · Guayaquil, Ecuador · Remoto LatAm**

[Ver portafolio](https://dodysalim.github.io/) · [GitHub](https://github.com/dodysalim) · [LinkedIn](https://www.linkedin.com/in/dody-dueñas-remache-079164296/)

Sitio estático con 13 proyectos (5 Henry, 4 No Country y 4 personales) de Henry, No Country y proyectos personales. Incluye búsqueda por nombre o tecnología, filtros por origen, español/inglés, enlaces Power BI y análisis interactivo de agregados bancarios.

## Módulo 4 de Henry

Una sola ficha reúne los dos trabajos del módulo; no se cuentan como dos proyectos distintos.

- [FinanceGuard](https://github.com/dodysalim/churn-prediction-financeguard): proyecto integrador localizado en la carpeta M4, con notebooks y Power BI.
- [HealthPredict](projects/healthpredict/README.md): práctica de clasificación revisada, notebook guiado y seis pruebas de integridad y separación por paciente.

## Código y vista local

- `index.html`: estructura y metadatos.
- `app.js`: catálogo, búsqueda, filtros, casos y análisis.
- `i18n.js`: traducción y detección español/inglés.
- `style.css`: presentación oscura y reglas adaptables al ancho.
- `bank-data.json`: agregados originales de la vista interactiva.

```bash
python -m http.server 8000
```

Abre http://localhost:8000. Para la práctica M4, sigue las instrucciones de su carpeta; sus datos originales aún faltan. Los archivos fuente Power BI de TechCore y Bank Transactions no están incorporados a este repositorio; sus fichas indican ese alcance.

## Actualizar y comprobar

Actualiza las fichas originales en `app.js` y sus traducciones en `i18n.js`. Comprueba los filtros de Henry / No Country / Personales, búsqueda vacía, diálogos, cambio de idioma y tabla de agregados. Mantén la atribución de proyectos colectivos y distingue pruebas, resultados de notebooks y escenarios simulados.

```bash
node --check app.js
node --check i18n.js
python -m pip install -r projects/healthpredict/requirements.txt
python -m pytest projects/healthpredict/tests -q -o pythonpath=projects/healthpredict
```

GitHub Pages publica la raíz de `main`; no necesita otro proveedor de hosting.

## ConversaAI · No Country

Caso NLP del equipo S04-26-40, con enlace a [ConversaAI](https://github.com/dodysalim/ConversaAI-NLP-Support-Analytics). Conserva la atribución del equipo y distingue el score heurístico de churn de una probabilidad calibrada.

## Selección para reclutadores y CV

La página inicial destaca Cliente360, KrioMetrics y ConversaAI. El botón de descarga enlaza a `assets/Dody_Duenas_CV.pdf`, versión de dos páginas que presenta la experiencia en proyectos de datos, aclara el contexto de No Country en una nota y contextualiza métricas y escenarios. El original adjunto se conserva fuera del repositorio.
