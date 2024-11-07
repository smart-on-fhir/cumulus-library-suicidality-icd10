-- # all ED visits

--    select
--    count(distinct subject_ref) as cnt_subjects,
--    count(distinct encounter_ref) as cnt_encounters
--    from
--    suicide_icd10__study_period
--    where doc_ed_note
--
--    cnt_subjects	cnt_encounters
--    59866	        90980

-- # grouped by race

--    select
--    count(distinct subject_ref) as cnt_subjects,
--    count(distinct encounter_ref) as cnt_encounters,
--    race_display
--    from
--    suicide_icd10__study_period
--    where doc_ed_note
--    group by race_display
--    order by race_display

--    #	subjects	ED visits	race_display
--    107           173	        [American Indian or Alaska Native]
--    2312	        3228	    [Asian]
--    9198	        16369	    [Black or African American]
--    57	        105	        [Native Hawaiian or Other Pacific Islander]
--    14861	        26088	    [Other]
--    27228	        37500	    [White]
--    6103	        7517	    [unknown]

--    select
--    count(distinct subject_ref) as cnt_subjects,
--    count(distinct encounter_ref) as cnt_encounters,
--    ethnicity_display
--    from
--    suicide_icd10__study_period
--    where doc_ed_note
--    group by ethnicity_display
--    order by ethnicity_display

--    cnt_subjects	cnt_encounters	ethnicity_display
--    2491	3154	[Declined to Answer]
--    10	14	[Hispanic or Latino]
--    3089	3746	[Unable to Answer]
--    491	577	[Unknown]
--    53785	83489	[unknown]

select
    count(distinct P.subject_ref) as cnt_subjects,
    count(distinct P.encounter_ref) as cnt_encounters,
    PSM.dx_suicidality
from
    suicide_icd10__psm_notes_balanced_oct26_detail_jan24 as PSM,
    suicide_icd10__study_period as P
where P.doc_ed_note
and   PSM.encounter_ref = P.encounter_ref
group by dx_suicidality

select
    count(distinct P.subject_ref) as cnt_subjects,
    count(distinct P.encounter_ref) as cnt_encounters,
    PSM.dx_suicidality,
    P.race_display
from
    suicide_icd10__psm_notes_balanced_oct26_detail_jan24 as PSM,
    suicide_icd10__study_period as P
where PSM.encounter_ref = P.encounter_ref
group by dx_suicidality, P.race_display
order by dx_suicidality, P.race_display

