"""HealthPredict: reproducible academic classification, split by patient."""
from __future__ import annotations
import argparse
import json
from pathlib import Path
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, roc_auc_score
from sklearn.model_selection import GroupShuffleSplit
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

NUMERIC = ['bmi', 'glucose', 'blood_pressure_sys', 'age']
CATEGORICAL = ['condition']
TARGET = 'outcome_risk'

def prepare_data(visits: pd.DataFrame, patients: pd.DataFrame,
                 extra_patients: pd.DataFrame | None = None) -> pd.DataFrame:
    """Join many visits to one patient; refuse ambiguous IDs and unknown targets."""
    patients = pd.concat([patients, extra_patients], ignore_index=True) if extra_patients is not None else patients.copy()
    # Direct identifiers such as names never enter the returned training table.
    patients = patients.drop(columns=['name'], errors='ignore').drop_duplicates()
    for name, frame in [('visits', visits), ('patients', patients)]:
        if 'patient_id' not in frame or frame['patient_id'].isna().any():
            raise ValueError(f'{name}: patient_id is required and cannot be null')
    if patients['patient_id'].duplicated().any():
        raise ValueError('Conflicting duplicate patient_id records in patients')
    merged = visits.merge(patients, on='patient_id', how='left', validate='many_to_one', indicator=True)
    if merged['_merge'].ne('both').any():
        raise ValueError('Visits contain patient IDs absent from patients')
    expected = ['patient_id', *NUMERIC, *CATEGORICAL, TARGET]
    missing = sorted(set(expected) - set(merged.columns))
    if missing:
        raise ValueError('Missing columns: '+', '.join(missing))
    data = merged[expected].copy()
    data[TARGET] = pd.to_numeric(data[TARGET], errors='raise')
    if data[TARGET].isna().any() or set(data[TARGET].unique()) != {0, 1}:
        raise ValueError('outcome_risk must contain both binary classes 0 and 1')
    for col in NUMERIC:
        data[col] = pd.to_numeric(data[col], errors='raise')
    return data

def fit_evaluate(data: pd.DataFrame, random_state: int = 42):
    """Patient-disjoint holdout: no person's visits appear in both partitions."""
    splitter = GroupShuffleSplit(n_splits=1, test_size=.2, random_state=random_state)
    train, test = next(splitter.split(data, data[TARGET], groups=data['patient_id']))
    if any(data.iloc[idx][TARGET].nunique() != 2 for idx in [train, test]):
        raise ValueError('Patient holdout lacks a class. Provide more patients or review the split; do not report an AUC.')
    numerical = Pipeline([('imputer', SimpleImputer(strategy='median', keep_empty_features=True)), ('scale', StandardScaler())])
    categorical = Pipeline([('imputer', SimpleImputer(strategy='most_frequent', keep_empty_features=True)), ('encode', OneHotEncoder(handle_unknown='ignore'))])
    prep = ColumnTransformer([('numeric', numerical, NUMERIC), ('categorical', categorical, CATEGORICAL)])
    model = Pipeline([('preprocessor', prep), ('classifier', LogisticRegression(max_iter=1000, random_state=random_state))])
    X, y = data[NUMERIC+CATEGORICAL], data[TARGET].astype(int)
    model.fit(X.iloc[train], y.iloc[train])
    predictions = model.predict(X.iloc[test]); probabilities = model.predict_proba(X.iloc[test])[:, 1]
    report = {'evaluation':'patient-disjoint holdout', 'random_state':random_state,
              'train_visits':len(train), 'test_visits':len(test),
              'train_patients':int(data.iloc[train]['patient_id'].nunique()),
              'test_patients':int(data.iloc[test]['patient_id'].nunique()),
              'roc_auc':float(roc_auc_score(y.iloc[test], probabilities)),
              'classification_report':classification_report(y.iloc[test], predictions, output_dict=True, zero_division=0),
              'confusion_matrix':confusion_matrix(y.iloc[test], predictions, labels=[0,1]).tolist()}
    return model, report, train, test

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--data-dir', type=Path, default=Path(__file__).resolve().parent/'data')
    parser.add_argument('--output', type=Path, default=Path(__file__).resolve().parent/'reports'/'metrics.json')
    args = parser.parse_args()
    visits_path=args.data_dir/'healthpredict_visits.csv';patients_path=args.data_dir/'healthpredict_patients.csv'
    missing=[p.name for p in [visits_path,patients_path] if not p.is_file()]
    if missing:parser.error('Missing original datasets: '+', '.join(missing))
    extra_path=args.data_dir/'pacientes2.csv'
    data=prepare_data(pd.read_csv(visits_path),pd.read_csv(patients_path),pd.read_csv(extra_path) if extra_path.exists() else None)
    _,report,_,_=fit_evaluate(data)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(f'Evaluation saved to {args.output}; academic use only.')

if __name__=='__main__':main()
