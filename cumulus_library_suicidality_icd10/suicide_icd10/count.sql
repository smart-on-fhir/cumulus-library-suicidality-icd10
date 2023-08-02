-- ###########################################################
CREATE TABLE suicide_icd10__count_dx_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_week, dx_subtype, dx_display, doc_ed_note, gender, race_display, age_at_visit, enc_class_code, doc_type_display        
        FROM suicide_icd10__dx
        group by CUBE
        ( cond_week, dx_subtype, dx_display, doc_ed_note, gender, race_display, age_at_visit, enc_class_code, doc_type_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_week, dx_subtype, dx_display, doc_ed_note, gender, race_display, age_at_visit, enc_class_code, doc_type_display
    from powerset 
    WHERE cnt_subject >= 5 
    ORDER BY cnt desc;

-- ###########################################################
CREATE TABLE suicide_icd10__count_dx_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_month, dx_subtype, dx_display, doc_ed_note, gender, race_display, age_at_visit, enc_class_code, doc_type_display        
        FROM suicide_icd10__dx
        group by CUBE
        ( cond_month, dx_subtype, dx_display, doc_ed_note, gender, race_display, age_at_visit, enc_class_code, doc_type_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_month, dx_subtype, dx_display, doc_ed_note, gender, race_display, age_at_visit, enc_class_code, doc_type_display
    from powerset 
    WHERE cnt_subject >= 5 
    ORDER BY cnt desc;

-- ###########################################################
CREATE TABLE suicide_icd10__count_study_period_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , enc_start_week, period, gender, age_group, race_display, doc_ed_note, enc_class_code, doc_type_display        
        FROM suicide_icd10__study_period
        group by CUBE
        ( enc_start_week, period, gender, age_group, race_display, doc_ed_note, enc_class_code, doc_type_display )
    )
    select
          cnt_encounter  as cnt 
        , enc_start_week, period, gender, age_group, race_display, doc_ed_note, enc_class_code, doc_type_display
    from powerset 
    WHERE cnt_subject >= 5 
    ORDER BY cnt desc;

-- ###########################################################
CREATE TABLE suicide_icd10__count_study_period_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , enc_start_month, period, gender, age_group, race_display, doc_ed_note, enc_class_code, doc_type_display        
        FROM suicide_icd10__study_period
        group by CUBE
        ( enc_start_month, period, gender, age_group, race_display, doc_ed_note, enc_class_code, doc_type_display )
    )
    select
          cnt_encounter  as cnt 
        , enc_start_month, period, gender, age_group, race_display, doc_ed_note, enc_class_code, doc_type_display
    from powerset 
    WHERE cnt_subject >= 5 
    ORDER BY cnt desc;
