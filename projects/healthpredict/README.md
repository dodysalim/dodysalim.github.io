<p align="center"><img src="https://dodysalim.github.io/assets/project-covers/m4.webp" alt="HealthPredict" width="100%"></p>

<h1 align="center">HealthPredict</h1>

<p align="center"><b>Clasificación de riesgo con un pipeline reproducible y evaluación separada por paciente.</b></p>

<p align="center">
<img src="https://img.shields.io/badge/Henry_%C2%B7_M%C3%B3dulo_4_%C2%B7_Pr%C3%A1ctica-75E6CE?style=for-the-badge&labelColor=0b1222" alt="Henry · Módulo 4 · Práctica">
</p>

<p align="center">
<img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python"> <img src="https://img.shields.io/badge/pandas-150458?style=flat-square&logo=pandas&logoColor=white" alt="pandas"> <img src="https://img.shields.io/badge/scikit--learn-F7931E?style=flat-square&logo=scikitlearn&logoColor=white" alt="scikit-learn"> <img src="https://img.shields.io/badge/Jupyter-F37626?style=flat-square&logo=jupyter&logoColor=white" alt="Jupyter">
</p>

<p align="center"><a href="https://dodysalim.github.io/"><b>🌐 Portafolio</b></a> · <a href="notebooks/HealthPredict.ipynb"><b>📓 Notebook guiado</b></a> · <a href="train.py"><b>🐍 Código</b></a></p>

---

## 📌 Resumen en 30 segundos

| | |
| --- | --- |
| **🎯 Problema** | Evitar fuga de información cuando un mismo paciente tiene varias visitas. |
| **🛠️ Solución** | Pipeline de scikit-learn con división por patient_id, imputación, escalado y validaciones de datos. |
| **📈 Entregables** | Script de entrenamiento con métricas en JSON y notebook guiado. |
| **🧪 Calidad** | 6 pruebas automatizadas (separación de pacientes, imputación, duplicados, columnas faltantes). |
| **👤 Autor** | Dody Dueñas Remache. |

## El problema

Unir visitas y pacientes, preparar variables clínicas del ejercicio y evaluar una clasificación binaria. Si un paciente tiene varias visitas, una división por filas puede colocar a la misma persona en entrenamiento y prueba. La versión revisada separa por `patient_id`.

## Cambios respecto al notebook localizado

- Rutas relativas y parámetro `--data-dir`, sin depender de un usuario de Windows.
- Validación de claves, pacientes duplicados, visitas sin paciente y target binario.
- Identificadores y nombres excluidos del modelo.
- Imputación, escalado y categorías dentro del pipeline, ajustados solo con entrenamiento.
- Modelo creado y entrenado antes de predecir; se elimina la referencia a `pre` sin definir.
- Reporte de clasificación, matriz de confusión y ROC-AUC solo al ejecutar con datos disponibles.

## Ejecutar

Desde esta carpeta, con Python 3.11 o 3.12:

```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# Linux/macOS: source .venv/bin/activate
python -m pip install -r requirements.txt
python train.py --data-dir data
```

Coloca en `data/` los CSV originales `healthpredict_visits.csv` y `healthpredict_patients.csv`; `pacientes2.csv` es opcional. No publiques datos identificables de pacientes. El programa escribe `reports/metrics.json`.

Columnas requeridas tras la unión: `patient_id`, `bmi`, `glucose`, `blood_pressure_sys`, `age`, `condition`, `outcome_risk`. El target debe contener las clases 0 y 1. Si hay columnas de características con el mismo nombre en ambas tablas, revisa el esquema antes de unirlas.

```bash
python -m pytest tests -q
python -m jupyter lab
```

## Qué se comprobó

**6 pruebas aprobadas** con datos sintéticos de prueba: separación de pacientes, categorías nuevas, imputación, claves desconocidas, duplicados y columnas faltantes. No son una evaluación del dataset original.

El notebook original se encontró en la carpeta M4, pero sus CSV no estaban disponibles. Por ello no se publica un AUC, precisión ni desempeño clínico. El proyecto es académico; el significado del target corresponde al ejercicio.

Se conserva [la fuente original sin salidas](notebooks/original_sin_salidas.ipynb) como referencia histórica; usa el notebook guiado para ejecutar la versión revisada.

## Autor

Dody Salim Dueñas Remache · formación Henry, módulo 4.

---

<p align="center">
<b>Dody Dueñas Remache</b> · Analista de Datos / Data Scientist<br>
<a href="https://dodysalim.github.io/">Portafolio</a> · <a href="https://github.com/dodysalim">GitHub</a> · <a href="https://www.linkedin.com/in/dody-duenas/">LinkedIn</a> · <a href="mailto:dodydurema67@gmail.com">dodydurema67@gmail.com</a>
</p>
