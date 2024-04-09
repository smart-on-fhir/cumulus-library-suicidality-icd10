create table suicide_icd10__code_usage as
select dx_subtype, dx_code_display, count(distinct encounter_ref) as cnt_encounter
from suicide_icd10__prevalence
group by cube(dx_subtype, dx_code_display)
order by cnt_encounter desc

--MANUAL QA: To produce the complete action-past list
--
--select dx_subtype, dx_code_display, count(encounter_ref) as cnt_encounter
--from suicide_icd10__prevalence
--where
--(dx_code like 'T%D') or (dx_code like 'X%D')
--or (dx_code like 'T%S') or (dx_code like 'X%S')
--group by dx_subtype, dx_code_display
--order by cnt_encounter desc

