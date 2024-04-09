--create table suicide_icd10__thesis_table1 as
--select
--count(distinct P.subject_ref) as cnt_subject,
--    P.dx_suicidality,
--    P.dx_subtype,
--    P.age_group,
--    P.gender
--from suicide_icd10__prevalence P, suicide_icd10__study_period S
--where P.encounter_ref = S.encounter_ref
--group by cube (
--    P.dx_suicidality,
--    P.dx_subtype,
--    P.age_group,
--    P.gender)
--order by
--    P.dx_suicidality,
--    P.dx_subtype,
--    P.age_group,
--    P.gender;

create table suicide_icd10__count_demographics as
select
    dx_suicidality, dx_subtype, age_group, gender,
    count(distinct encounter_ref) as cnt_encounter,
    count(distinct subject_ref) as cnt_subject
from suicide_icd10__prevalence
where doc_ed_note
group by cube(dx_suicidality, dx_subtype, age_group, gender)
order by cnt_encounter desc, cnt_subject desc

