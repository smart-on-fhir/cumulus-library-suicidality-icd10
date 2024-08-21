--- TODO: notice this is not completed and should not yet be used for chart selection

create or replace view suicide_icd10__compare as
select distinct
       C.recorded_year
     , C.cond_code.code
     , P.gender
     , C.subject_ref
     , C.encounter_ref
     , doc.doc_ref
     , doc.doc_type_code
     , doc.doc_type_display
from
     core__patient as P
    ,core__condition as C
    ,core__documentreference as doc
    ,core__ed_note as SITE
where
    P.subject_ref = C.subject_ref
and C.encounter_ref = doc.encounter_ref
and doc.doc_type_code = SITE.from_code
and C.cond_code.code in (
    'F32.9', 'F41.1', 'F41.9', 'F90.9', 'F32.89'
    , 'F33.8', 'F90.2', 'F32.A', 'F99', 'F43.12')
order by encounter_ref;

--select
--F32.9 Major depression NOS
--F32.A Depression NOS
--F41.9 Anxiety NOS
--F41.1 Anxiety state
--F90.2 Attention-deficit hyperactivity disorder, combined type
--F90.9 Attention-deficit hyperactivity disorder NOS
--F32.89 Atypical depression
--F33.8 Recurrent brief depressive episodes
--F43.12 Post-traumatic stress disorder, chronic
