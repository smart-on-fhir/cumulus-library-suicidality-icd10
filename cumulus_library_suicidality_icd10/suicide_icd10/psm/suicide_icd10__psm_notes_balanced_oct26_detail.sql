create table suicide_icd10__psm_notes_balanced_oct26_detail_labelstudio as
WITH
Cohort as (
    select distinct
            subject_ref,    encounter_ref,   enc_start_date,
            dx_suicidality, dx_subtype,     dx_code,
            case
            when dx_subtype = 'None'        then 'None'
            when dx_subtype = 'ideation'    then 'ideation'
            when dx_subtype = 'attempt'     then 'action'
            when dx_subtype = 'self_harm'   then 'action'
            else 'impossible' end as label
    from    suicide_icd10__prevalence
    order by subject_ref,    encounter_ref,   enc_start_date
),
CaseDef as (
    select distinct
            Cohort.subject_ref,     Cohort.encounter_ref,   Cohort.enc_start_date,
            Cohort.dx_suicidality,  Cohort.dx_subtype,      Cohort.dx_code, Cohort.label
    from    suicide_icd10__psm_notes_balanced_oct26 as PSM, Cohort
    where   PSM.subject_ref = Cohort.subject_ref
    and     PSM.is_case
),
CaseMatched as (
    select distinct
            Cohort.subject_ref,     Cohort.encounter_ref,   Cohort.enc_start_date,
            Cohort.dx_suicidality,  Cohort.dx_subtype,      Cohort.dx_code,
            Cohort.label
    from    suicide_icd10__psm_notes_balanced_oct26 as PSM, Cohort
    where   PSM.matched_ref = Cohort.subject_ref
    and     NOT PSM.is_case
),
Merged as (
    select distinct * from CaseDef
    union
    select distinct * from CaseMatched
),
Present as (
    select distinct
        Merged.subject_ref,     Merged.enc_start_date,  Merged.encounter_ref,
        Merged.dx_suicidality,  Merged.dx_subtype,      Merged.dx_code,
    case
        when    dx_code in ('Z91.5', 'Z91.51', 'Z91.52') then 'action-past'
        else    concat(Merged.label, '-present') end as label
    from Merged
),
History as (
    select distinct
        Present.subject_ref,     Present.enc_start_date,    Present.encounter_ref,
        Previous.dx_suicidality, Previous.dx_subtype,       Previous.dx_code,
        concat(Previous.label, '-past') as label
    from    Merged as Previous, Present
    where   Previous.dx_suicidality
    and     Previous.subject_ref = Present.subject_ref
    and     date(Previous.enc_start_date) < date(Present.enc_start_date)
),
HPI as (
    select * from Present
    UNION
    select * from History
)
select distinct
            subject_ref,    encounter_ref,   enc_start_date,
            dx_suicidality, dx_subtype,      dx_code,
            label
from HPI
order by subject_ref, enc_start_date, encounter_ref, label, dx_subtype, dx_code
;