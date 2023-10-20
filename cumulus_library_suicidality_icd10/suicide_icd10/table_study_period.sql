drop table if exists suicide_icd10__study_period;

create TABLE suicide_icd10__study_period AS
    select distinct P.period, A.age_group,
        S.ed_note as doc_ed_note,
        S.diff_enc_note_days,
        S.age_at_visit,
        S.gender,
        S.race_display,
        S.ethnicity_display,
        S.enc_class_code,
        S.enc_class_display,
        S.doc_type_code,
        S.doc_type_display,
        S.start_date as enc_start_date, -- FHIR Encounter
        S.start_week as enc_start_week,
        S.start_month as enc_start_month,
        S.end_date as enc_end_date,
        S.author_date as doc_author_date, -- FHIR DocumentReference
        S.author_week as doc_author_week,
        S.author_month as doc_author_month,
        S.author_year as doc_author_year,
        S.subject_ref,
        S.encounter_ref,
        e.status,
        S.doc_ref
    from core__study_period AS S,
        suicide_icd10__define_age AS A,
        suicide_icd10__define_study_period AS P,
        core__encounter AS e
    where S.age_at_visit = A.age
      and (S.author_date between P.period_start and P.period_end)
      and e.encounter_ref = S.encounter_ref
;
