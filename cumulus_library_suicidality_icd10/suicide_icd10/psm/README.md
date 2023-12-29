# How the Cohort was created 

1. suicide_icd10__psm_notes
2. suicide_icd10__psm_notes_balanced_oct26
3. suicide_icd10__psm_notes_balanced_oct26_detail
4. suicide_icd10__psm_notes_balanced_oct26_outliers

#### Debugging the small DIFFS: which NOTES were selected vs. SHOULD have been selected for chart-review  

**190 vs 188 subjects**

    select count(distinct PSM.subject_ref) as cnt 
    from    suicide_icd10__psm_notes_balanced_oct26 as PSM, 
            suicide_icd10__prevalence as Prev 
    where PSM.encounter_ref = Prev.encounter_ref

**383 vs 400 encounters**

    select count(distinct PSM.encounter_ref) as cnt 
    from    suicide_icd10__psm_notes_balanced_oct26 as PSM, 
            suicide_icd10__prevalence as Prev 
    where PSM.encounter_ref = Prev.encounter_ref

**spotchecking**

    select * from suicide_icd10__psm_notes_balanced_oct26_detail
    order by subject_ref, enc_start_date, encounter_ref, label
    limit 100

    Patient/0113170c-d242-4a4f-9b2f-ebd10ba0ab25

