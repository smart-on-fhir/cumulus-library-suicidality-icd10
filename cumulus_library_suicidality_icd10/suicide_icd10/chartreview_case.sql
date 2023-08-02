drop table if exists suicide_icd10__case;

create table suicide_icd10__case AS
with ED as
(
    select distinct dx_subtype, cond_year, gender, subject_ref, encounter_ref from suicide_icd10__dx where doc_ed_note = True
)
,ed2016 as (select * from ED where cond_year = date('2016-01-01') limit 10)
,ed2017 as (select * from ED where cond_year = date('2017-01-01') limit 10)
,ed2018 as (select * from ED where cond_year = date('2018-01-01') limit 10)
,ed2019 as (select * from ED where cond_year = date('2019-01-01') limit 10)
,ed2020 as (select * from ED where cond_year = date('2020-01-01') limit 10)
,ed2021 as (select * from ED where cond_year = date('2021-01-01') limit 10)
,ed2022 as (select * from ED where cond_year = date('2022-01-01') limit 10)
,combine as
(
    select * from ed2016
    union
    select * from ed2017
    union
    select * from ed2018
    union
    select * from ed2019
    union
    select * from ed2020
    union
    select * from ed2021
    union
    select * from ed2022
)
select distinct
     C.dx_subtype, C.cond_year, C.gender
    ,C.subject_ref, C.encounter_ref, doc.doc_ref
    ,doc.doc_type_code
    ,doc.doc_type_display
from
     combine C
    ,core_documentreference as doc
where
    C.encounter_ref = doc.encounter_ref;

-- ########################################################################

-- suicidality_define_note_types
--#############################
-- NOTE:149798455   Emergency MD
-- NOTE:189094716   Psychiatry Evaluation
-- NOTE:262402257   Psychiatry Evaluation Consultation
-- NOTE:3710478     Discharge Summary


--desc suicide_icd10__case_note
--#############################
--dx_subtype	     ideation, self-harm, attempt
--cond_year      	 year of suicidality diagnosis
--doc_type_code      ED Note, Psych Consult, Discharge (code)
--doc_type_display   ED Note, Psych Consult, Discharge (human readable)
--doc_author_date    date of documented evidence of an ED encounter
--gender             patient gender
--subject_ref        link to core__patient
--encounter_ref      link to core__encounter
--doc_ref            link to core__documentreference

create table suicide_icd10__case_note AS
select distinct C.*, NOTE.author_date as doc_author_date
from
  suicide_icd10__case as C
, core__documentreference as NOTE
, suicide_icd10__define_note T
where C.doc_type_code = T.from_code
and C.encounter_ref = NOTE.encounter_ref
order by C.encounter_ref, NOTE.author_date;