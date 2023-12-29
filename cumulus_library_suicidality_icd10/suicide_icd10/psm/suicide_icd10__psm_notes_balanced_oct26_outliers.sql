create table suicide_icd10__psm_notes_balanced_oct26_outliers as
with missing_from_pop_selection as
(
    select  PSM.encounter_ref
    from    suicide_icd10__psm_notes_balanced_oct26 as PSM
    where   PSM.encounter_ref not in
        (select distinct encounter_ref from suicide_icd10__study_period)
),
should_exclude as
(
    select distinct
            subject_ref, encounter_ref,
            age_at_visit, start_date, author_date,
            doc_type_code, doc_type_display
    from    core__study_period
    where
            encounter_ref in
        (select distinct encounter_ref from missing_from_pop_selection)
)
select distinct
        subject_ref, encounter_ref,
        age_at_visit, start_date, author_date,
        doc_type_code, doc_type_display
from should_exclude, suicide_icd10__define_note as NoteType
where should_exclude.doc_type_code =  NoteType.from_code;