SELECT COUNT(DISTINCT P.subject_ref) AS cnt,
    P.dx_suicidality, C.code_display
FROM
    suicide_icd10__prevalence as P,
    core__condition C
WHERE P.doc_ed_note = True
and   P.dx_suicidality
and   P.subject_ref = C.subject_ref
GROUP BY cube(dx_suicidality, code_display)
order by cnt desc