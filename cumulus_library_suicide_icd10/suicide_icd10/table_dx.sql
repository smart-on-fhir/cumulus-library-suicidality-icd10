create TABLE suicide_icd10__dx as
    select distinct
          C.subject_ref
        , S.encounter_ref
        , DX.code    as icd10_code
        , DX.subtype as case_subtype
        , recorded_week
        , recorded_month
        , recorded_year
        , gender
        , race_display
        , age_at_visit
        , age_group
        , enc_class_code
        , doc_type_code
        , ed_note
        , period
    from  core__condition C
        ,   suicide_icd10__study_period S
        ,   suicide_icd10__define_dx DX
    where C.cond_code.coding[1].code = DX.code -- TODO https://github.com/smart-on-fhir/cumulus-library/issues/52
    and   C.encounter_ref = S.encounter_ref
    and   C.subject_ref = S.subject_ref
    order by recorded_month desc, case_subtype, icd10_code
;
