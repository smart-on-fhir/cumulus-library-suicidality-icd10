--action-present
--action-past
--ideation-present
--ideation-past
--None-present

create table suicide_icd10__psm_notes_balanced_oct26_priority as
WITH cohort as
(
    select  distinct subject_ref, encounter_ref, enc_start_date, label
    from    suicide_icd10__psm_notes_balanced_oct26_detail
    order by subject_ref, encounter_ref, label
),
action_present as
(
    select  distinct subject_ref, encounter_ref, label
    from    cohort
    where   label = 'action-present'
),
action_past as
(
    select  distinct subject_ref, encounter_ref, label
    from    cohort
    where   label = 'action-past'
),
ideation_present as
(
    select  distinct subject_ref, encounter_ref, label
    from    cohort
    where   label = 'ideation-present'
),
ideation_past as
(
    select  distinct subject_ref, encounter_ref, label
    from    cohort
    where   label = 'ideation-past'
),
none_present as
(
    select  distinct subject_ref, encounter_ref, label
    from    cohort
    where   label = 'None-present'
)
select distinct C.subject_ref, C.encounter_ref,   C.enc_start_date,
    case
        when action_present.label   is not null then action_present.label
        when action_past.label      is not null then action_past.label
        when ideation_present.label is not null then ideation_present.label
        when ideation_past.label    is not null then ideation_past.label
        when none_present.label     is not null then none_present.label
    else 'impossible' end as label
from cohort as C
left join action_present    on C.encounter_ref = action_present.encounter_ref
left join action_past       on C.encounter_ref = action_past.encounter_ref
left join ideation_present  on C.encounter_ref = ideation_present.encounter_ref
left join ideation_past     on C.encounter_ref = ideation_past.encounter_ref
left join none_present      on C.encounter_ref = none_present.encounter_ref
;