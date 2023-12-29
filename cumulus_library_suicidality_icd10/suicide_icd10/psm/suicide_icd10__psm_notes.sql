create or replace view suicide_icd10__psm_notes as with
case_list as
(
    select distinct
        True  as is_case
        , PSM.subject_ref
        , PSM.matched_ref
        , ENC.encounter_ref
        , NOTE.doc_ref
        , NOTE.doc_type_code
        , NOTE.doc_type_display
        , NOTE.author_date
    from
          suicide_icd10__psm as PSM
        , suicide_icd10__dx as DX
        , suicide_icd10__define_note as NOTE_TYPE
        , core__documentreference as NOTE
        , core__encounter as ENC
    where
        PSM.subject_ref = DX.subject_ref and
        DX.encounter_ref = ENC.encounter_ref and
        ENC.encounter_ref = NOTE.encounter_ref and
        NOTE.doc_type_code = NOTE_TYPE.from_code
    order by
        ENC.encounter_ref, NOTE.author_date
),
match_list as
(
    select distinct
          False  as is_case
        , PSM.subject_ref
        , PSM.matched_ref
        , ENC.encounter_ref
        , NOTE.doc_ref
        , NOTE.doc_type_code
        , NOTE.doc_type_display
        , NOTE.author_date
    from
          suicide_icd10__psm as PSM
        , suicide_icd10__define_note as NOTE_TYPE
        , core__documentreference as NOTE
        , core__encounter as ENC
    where
        PSM.matched_ref = ENC.subject_ref and
        ENC.encounter_ref = NOTE.encounter_ref and
        NOTE.doc_type_code = NOTE_TYPE.from_code
    order by
        ENC.encounter_ref, NOTE.author_date
)
select * from case_list
union
select * from match_list
order by is_case, encounter_ref, author_date;