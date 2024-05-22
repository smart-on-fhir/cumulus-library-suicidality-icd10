with ideation as
(
    select distinct 'ideation' as subtype, 'present'  as temporal, code, display
    from suicide_icd10__define_dx_ideation
),
attempt_present as
(
    select distinct 'attempt' as subtype, 'present'  as temporal, code, display
    from suicide_icd10__define_dx_attempt
    where code in ('T14.91', 'T14.91XA')
),
attempt_past_present as
(
    select distinct 'attempt' as subtype, 'past_present'  as temporal, code, display
    from suicide_icd10__define_dx_attempt
    where code in ('T14.91XD', 'T14.91XS')
),
self_harm_history_of as
(
    select distinct 'self_harm' as subtype, 'past'  as temporal, code, display
    from suicide_icd10__define_dx_self_harm
    where code in ('Z91.5', 'Z91.51', 'Z91.52')
),
self_harm_present as
(
    select distinct 'self_harm' as subtype, 'present' as temporal, code, display
    from suicide_icd10__define_dx_self_harm
    where code not in (select distinct code from self_harm_history_of)
),
self_harm_past_present as
(
    select distinct 'self_harm' as subtype, 'past_present' as temporal, code, display
    from suicide_icd10__define_dx_self_harm
    where   (code like 'T%D') or (code like 'X%D') or
            (code like 'T%S') or (code like 'X%S')
),
union_all as
(
    select subtype, temporal, code, display from ideation
    UNION
    select subtype, temporal, code, display from attempt_present
    UNION
    select subtype, 'past', code, display from attempt_past_present
    UNION
    select subtype, 'present', code, display from attempt_past_present
    UNION
    select subtype, temporal, code, display from self_harm_history_of
    UNION
    select subtype, temporal, code, display from self_harm_present
    UNION
    select subtype, 'past', code, display from self_harm_past_present
    UNION
    select subtype, 'present', code, display from self_harm_past_present
)
select distinct
    case when subtype = 'ideation'  then 'ideation' else 'action'  end as ideation_action,
    subtype, temporal, code, display
from union_all
order by ideation_action desc, subtype, code, temporal;