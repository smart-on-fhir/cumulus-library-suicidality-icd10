create table suicide_icd10__psm_notes_balanced_oct26 as
with case_visits as
(
	select distinct encounter_ref from suicide_icd10__psm_notes where is_case = True
	order by encounter_ref
	limit 200
),
match_visits as
(
	select distinct encounter_ref from suicide_icd10__psm_notes where is_case = False
	order by encounter_ref
	limit 200
),
balanced as
(
	select * from case_visits UNION select * from match_visits
)
select PSM.*
from
	balanced,
	suicide_icd10__psm_notes as PSM
where
	balanced.encounter_ref = PSM.encounter_ref
order by encounter_ref, author_date;
