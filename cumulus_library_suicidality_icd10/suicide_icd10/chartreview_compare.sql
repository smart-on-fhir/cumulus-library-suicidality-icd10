create or replace view suicide_icd10_compare as
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

--<View>
--  <Labels name="label" toName="text">
--    <Label value="ideation" background="#ffff00"/>
--    <Label value="self-harm" background="#ff3300"/>
--    <Label value="attempt" background="#993333"/>
--    <Label value="gender-differs-sex" background="#5cd65c"/>
--    <Label value="depression" background="#0073e6"/>
--    <Label value="anxiety" background="#ff9933"/>
--    <Label value="other-mental-cond" background="#cc00cc"/>
--  </Labels>
--  <Text name="text" value="$text"/>
--</View>