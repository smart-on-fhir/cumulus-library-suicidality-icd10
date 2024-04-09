create table suicide_icd10__psm_notes_balanced_oct26_detail_jan24 as
WITH
Prevalence as (
    select distinct
            subject_ref,    encounter_ref,
            dx_suicidality, dx_subtype,     dx_code,
            case
            when dx_subtype = 'None'        then 'None'
            when dx_subtype = 'ideation'    then 'ideation'
            when dx_subtype = 'attempt'     then 'action'
            when dx_subtype = 'self_harm'   then 'action'
            else 'impossible' end as label
    from    suicide_icd10__prevalence
    order by subject_ref,    encounter_ref
),
-- PSM.subject_ref "patient has suicidality"
CaseDef as (
    select distinct
            Prevalence.subject_ref,     Prevalence.encounter_ref,
            Prevalence.dx_suicidality,  Prevalence.dx_subtype,      Prevalence.dx_code,
            Prevalence.label
    from    suicide_icd10__psm_notes_balanced_oct26 as PSM, Prevalence
    where   PSM.subject_ref = Prevalence.subject_ref
    and     PSM.encounter_ref = Prevalence.encounter_ref
    and     PSM.is_case
),
-- PSM.matched_ref "case matched controls"
CaseMatched as (
    select distinct
            Prevalence.subject_ref,     Prevalence.encounter_ref,
            Prevalence.dx_suicidality,  Prevalence.dx_subtype,      Prevalence.dx_code,
            Prevalence.label
    from    suicide_icd10__psm_notes_balanced_oct26 as PSM, Prevalence
    where   PSM.matched_ref = Prevalence.subject_ref
    and     PSM.encounter_ref = Prevalence.encounter_ref
    and     NOT PSM.is_case
),
CasePastPresent as (
    select distinct
        CaseDef.subject_ref,     CaseDef.encounter_ref,
        CaseDef.dx_suicidality,  CaseDef.dx_subtype,      CaseDef.dx_code,
    case
        when    dx_code in ('Z91.5', 'Z91.51', 'Z91.52') then 'action-past'     -- history of self harm
        when    (dx_code like 'T%D') or (dx_code like 'X%D')    then 'action-past-present'  -- subsequent suicide attempt, and other codes for subsequent encounter
        when    (dx_code like 'T%S') or (dx_code like 'X%S')    then 'action-past-present'  -- subsequent encounter
        else    concat(CaseDef.label, '-present') end as label
    from CaseDef
),
ActionPast as (
    select distinct
        subject_ref, encounter_ref, dx_suicidality, dx_subtype, dx_code, 'action-past' as label
    from CasePastPresent
    where label in ('action-past-present', 'action-past')
),
ActionPresent as (
    select distinct
        subject_ref, encounter_ref, dx_suicidality, dx_subtype, dx_code, 'action-present' as label
    from CasePastPresent
    where label in ('action-past-present', 'action-present')
),
Actions as (
    select distinct * from ActionPast
    union
    select distinct * from ActionPresent
),
Ideations as (
    select distinct
        subject_ref, encounter_ref, dx_suicidality, dx_subtype, dx_code, label
    from CasePastPresent
    where label in ('ideation-present', 'ideation-past')
),
Cohort as (
    select distinct * from CaseMatched
    union
    select distinct * from Actions
    union
    select distinct * from Ideations
)
select distinct
    subject_ref, encounter_ref, dx_suicidality, dx_subtype, dx_code,
    NULLIF(label, 'None') as label
from Cohort
order by subject_ref, encounter_ref, label, dx_subtype, dx_code
;