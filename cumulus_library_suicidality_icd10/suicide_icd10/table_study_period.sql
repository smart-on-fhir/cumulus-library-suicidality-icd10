drop table if exists suicide_icd10__study_period;

create TABLE suicide_icd10__study_period AS
    select distinct P.period, A.age_group, S.*
    from core__study_period S
        , suicide_icd10__define_age A
        , suicide_icd10__define_study_period P
    where S.age_at_visit = A.age
      and (S.author_date between P.period_start and P.period_end)
;
