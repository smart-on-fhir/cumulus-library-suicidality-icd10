create TABLE suicide_icd10__dx as
with flat_condition as
(
    select * from core__condition,
    unnest(cond_code.coding) AS t1 (code_coding)
)
    select distinct
        DX.subtype as dx_subtype,
        DX.code    as dx_code,
        DX.display as dx_display,
        DX.system  as dx_system,
        S.ed_note,
        S.diff_enc_note_days,
        S.period,
        S.age_at_visit,
        S.gender,
        S.race_display,
        S.ethnicity_display,
        S.enc_class_code,
        S.doc_type_code,
        S.doc_type_display,
        C.recorded_week, -- FHIR Condition
        C.recorded_month,
        C.recorded_year,
        S.start_date, -- FHIR Encounter
        S.start_week,
        S.start_month,
        S.end_date,
        S.author_date, -- FHIR DocumentReference
        S.author_week,
        S.author_month,
        S.author_year,
        S.subject_ref,
        S.encounter_ref,
        S.doc_ref
    from  flat_condition C
        ,   suicide_icd10__study_period S
        ,   suicide_icd10__define_dx DX
    where C.code_coding.code = DX.code
    and   C.encounter_ref = S.encounter_ref
    and   C.subject_ref = S.subject_ref
    order by recorded_month desc, subtype, dx_code
;
