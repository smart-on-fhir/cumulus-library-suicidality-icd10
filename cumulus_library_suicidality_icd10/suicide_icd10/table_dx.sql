create TABLE suicide_icd10__dx as
with flat_condition as
(
    select * from core__condition,
    unnest(cond_code.coding) AS t1 (code_coding)
)
    select distinct
        DX.subtype as dx_subtype,
        DX.system  as dx_system,
        DX.code    as dx_code,
        DX.display as dx_display,
        concat(DX.code, ' : ', DX.display) as dx_code_display,
        S.doc_ed_note,
        S.diff_enc_note_days,
        S.period,
        S.age_group,
        S.age_at_visit,
        S.gender,
        S.race_display,
        S.ethnicity_display,
        S.enc_class_code,
        S.doc_type_code,
        S.doc_type_display,
        C.category as cond_category,
        C.recorded_week as cond_week, -- FHIR Condition
        C.recorded_month as cond_month,
        C.recorded_year as cond_year,
        S.enc_start_date, -- FHIR Encounter
        S.enc_start_week,
        S.enc_start_month,
        S.enc_end_date,
        S.doc_author_date, -- FHIR DocumentReference
        S.doc_author_week,
        S.doc_author_month,
        S.doc_author_year,
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
