create table suicide_icd10__table1_study_period as
select
    dx_suicidality, dx_subtype, age_group, gender,
    count(distinct encounter_ref) as cnt_encounter,
    count(distinct subject_ref) as cnt_subject
from suicide_icd10__prevalence
where doc_ed_note
group by cube(dx_suicidality, dx_subtype, age_group, gender)
order by cnt_encounter desc, cnt_subject desc

-- #############################################################################
create table suicide_icd10__ignore_chart_ids
as select * from (VALUES
 ('0ac2d58f-fe05-46b0-975c-e050d44eb8dc')
,('5ab77a95-1ed6-4b98-8395-0e118b540451')
,('4d3d50f9-232e-45ed-b1c6-228605b833db')
,('412e23b7-46f2-4d90-b295-06ff2f55a21b')
,('4a5f3cc1-4054-4741-befb-0020e8a45902')
,('35205ac6-ba0b-476c-875c-1860ef42ca9f')
,('37703928-24d5-4db6-9686-a94b2a4fef95')
,('52d57d01-45a4-430b-881c-717fe831c2b8')
,('437bb996-7e63-45cc-875a-1fc3e0fc1b9e')
,('2181fffd-0a95-40b9-9129-26b8d71957de')
,('30254bd9-ed02-4ef2-90c1-48bc87eee7aa')
,('2502b6f9-9291-435f-a631-2e34527b04f0')
,('460f4d2f-6058-4e8d-b468-3a941ea736af')
,('3525a160-e461-440c-bed1-f71bc9854bdd')
,('2496a6fc-e18c-4136-b446-5aaa4fdaa050')
,('4f23ae77-23b9-4c16-962f-818d55d77d8b')
,('3ce68be0-e9b8-44e8-a6e5-a7a84763b991')
,('40e4877f-1e82-4f05-9e6c-5d141ef0e0b7')
)
AS t (ignore_id);

create table suicide_icd10__table1_chart_ids as
select count(distinct PSM.encounter_ref) as cnt_encounters,
    study_period.gender,
    study_period.age_group,
    PSM.dx_suicidality
from
    suicide_icd10__study_period as study_period,
    suicide_icd10__psm_notes_balanced_oct26_detail as PSM,
    suicide_icd10__define_chart_ids as charts
where
    PSM.encounter_ref = study_period.encounter_ref  and
    PSM.encounter_ref = charts.anonymized_fhir_id   and
    PSM.encounter_ref not in
        (select concat('Encounter/', ignore_id) from suicide_icd10__ignore_chart_ids)
group by CUBE(gender, age_group, dx_suicidality)
order by gender asc, age_group desc, dx_suicidality asc;


