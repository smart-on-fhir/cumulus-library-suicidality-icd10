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

**checking past and present coding**

PSM selection 

    select is_case, count(distinct encounter_ref) as cnt_encounter 
    from suicide_icd10__psm_notes_balanced_oct26
    group by is_case

Labels action-present AND action-past

    with action_present as 
    (
        select encounter_ref, subject_ref
        from suicide_icd10__psm_notes_balanced_oct26_detail
        where label in ('action-present', 'action-past-present')
    ), 
    action_past as 
    (
        select encounter_ref, subject_ref
        from suicide_icd10__psm_notes_balanced_oct26_detail
        where label in ('action-past', 'action-past-present')
    )
    select 
    count(distinct action_present.subject_ref)      as cnt_subject, 
    count(distinct action_present.encounter_ref)    as cnt_encounter 
    from action_present, action_past
    where action_present.encounter_ref = action_past.encounter_ref


**agreement**

{3713, 3714, 3715, 3716, 3717, 3718, 3719, 3720, 3721, 3722, 3723, 3724, 3725, 3726, 3727, 3728}