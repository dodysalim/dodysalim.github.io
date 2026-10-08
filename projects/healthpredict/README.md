# HealthPredict · Práctica Henry M4

**Clasificación académica de riesgo con un pipeline reproducible y evaluación por paciente.**

Python · pandas · scikit-learn · Regresión logística

[Portafolio](https://dodysalim.github.io/) · [Notebook guiado](notebooks/HealthPredict.ipynb) · [Código](train.py)

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
