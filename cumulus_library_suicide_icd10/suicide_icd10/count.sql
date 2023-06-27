-- ###########################################################
CREATE or replace VIEW suicide_icd10__count_dx_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , recorded_week, case_subtype, icd10_code, gender, race_display, age_at_visit, enc_class_code, doc_type_code, ed_note        
        FROM suicide_icd10__dx
        group by CUBE
        ( recorded_week, case_subtype, icd10_code, gender, race_display, age_at_visit, enc_class_code, doc_type_code, ed_note )
    )
    select
          cnt_encounter  as cnt 
        , recorded_week, case_subtype, icd10_code, gender, race_display, age_at_visit, enc_class_code, doc_type_code, ed_note
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;

-- ###########################################################
CREATE or replace VIEW suicide_icd10__count_dx_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , recorded_month, case_subtype, icd10_code, gender, race_display, age_at_visit, enc_class_code, doc_type_code, ed_note        
        FROM suicide_icd10__dx
        group by CUBE
        ( recorded_month, case_subtype, icd10_code, gender, race_display, age_at_visit, enc_class_code, doc_type_code, ed_note )
    )
    select
          cnt_encounter  as cnt 
        , recorded_month, case_subtype, icd10_code, gender, race_display, age_at_visit, enc_class_code, doc_type_code, ed_note
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;

-- ###########################################################
CREATE or replace VIEW suicide_icd10__count_study_period_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_week, period, gender, age_group, race_display        
        FROM suicide_icd10__study_period
        group by CUBE
        ( start_week, period, gender, age_group, race_display )
    )
    select
          cnt_encounter  as cnt 
        , start_week, period, gender, age_group, race_display
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;

-- ###########################################################
CREATE or replace VIEW suicide_icd10__count_study_period_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_month, period, gender, age_group, race_display        
        FROM suicide_icd10__study_period
        group by CUBE
        ( start_month, period, gender, age_group, race_display )
    )
    select
          cnt_encounter  as cnt 
        , start_month, period, gender, age_group, race_display
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;

-- ###########################################################
CREATE or replace VIEW suicide_icd10__count_study_period_year AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_year, period, gender, age_group, race_display        
        FROM suicide_icd10__study_period
        group by CUBE
        ( start_year, period, gender, age_group, race_display )
    )
    select
          cnt_encounter  as cnt 
        , start_year, period, gender, age_group, race_display
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;
