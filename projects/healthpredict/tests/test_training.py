import numpy as np
import pandas as pd
import pytest
from train import prepare_data, fit_evaluate

def sample():
    rng=np.random.default_rng(42);n=120
    patients=pd.DataFrame({'patient_id':range(n),'name':['Private name']*n,'age':rng.integers(20,80,n),'condition':['A','B']*(n//2)})
    visits=pd.DataFrame({'patient_id':np.repeat(np.arange(n),2),'bmi':rng.normal(25,4,2*n),'glucose':rng.normal(110,20,2*n),'blood_pressure_sys':rng.normal(125,15,2*n),'outcome_risk':np.repeat(np.arange(n)%2,2)})
    return visits,patients

def test_patient_partition_and_private_identifiers():
    visits,patients=sample();data=prepare_data(visits,patients)
    assert 'name' not in data
    model,report,train,test=fit_evaluate(data)
    assert set(data.iloc[train].patient_id).isdisjoint(data.iloc[test].patient_id)
    assert 'patient_id' not in model.feature_names_in_
    assert 0 <= report['roc_auc'] <= 1
    unseen=data.iloc[[0]].copy();unseen['condition']='unseen category';unseen['bmi']=np.nan
    assert len(model.predict(unseen))==1

def test_unmatched_patient_rejected():
    visits,patients=sample()
    with pytest.raises(ValueError,match='absent'):prepare_data(visits,patients.iloc[1:])

def test_conflicting_duplicates_rejected():
    visits,patients=sample();conflict=patients.iloc[[0]].copy();conflict['age']=999
    with pytest.raises(ValueError,match='Conflicting'):prepare_data(visits,patients,conflict)

def test_identical_duplicates_do_not_multiply_visits():
    visits,patients=sample();assert len(prepare_data(visits,patients,patients.iloc[[0]]))==len(visits)

def test_invalid_target_rejected():
    visits,patients=sample();visits.loc[0,'outcome_risk']=3
    with pytest.raises(ValueError,match='binary'):prepare_data(visits,patients)

def test_missing_feature_has_actionable_error():
    visits,patients=sample()
    with pytest.raises(ValueError,match='glucose'):prepare_data(visits.drop(columns='glucose'),patients)
