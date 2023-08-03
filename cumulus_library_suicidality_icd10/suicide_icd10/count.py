from typing import List
from cumulus_library.schema import counts

# https://github.com/smart-on-fhir/cumulus-library-template/issues/2
STUDY_PREFIX = 'suicide_icd10'

def table(tablename: str, duration=None) -> str:
    if duration:
        return f'{STUDY_PREFIX}__{tablename}_{duration}'
    else: 
        return f'{STUDY_PREFIX}__{tablename}'

def count_dx(duration='month'):
    """
    Encounter Diagnosis, not exactly 'incidence' because DX may not be "new".

    Stratify variables for "documented encounter"

    :return: str suicide_icd10__count_dx_month
    """
    view_name = table('count_dx', duration)
    from_table = table('dx')
    cols = [f'cond_{duration}',
            'dx_subtype',
            'dx_display',
            'gender',
            'race_display',
            'age_at_visit',
            'enc_class_code',
            'doc_ed_note',
            'doc_type_display']
    return counts.count_encounter(view_name, from_table, cols)

def count_prevalence(duration='month'):
    """
    Percentage of patients with a suicidality diagnosis

    :return: str suicide_icd10__count_prevalence_month
    """
    view_name = table('count_prevalence', duration)
    from_table = table('prevalence')
    cols = [f'enc_start_{duration}',
            'dx_subtype',
            'period',
            'gender',
            'age_group',
            'doc_ed_note',
            'enc_class_code']

    return counts.count_encounter(view_name, from_table, cols)

def count_study_period(duration='month'):
    """
    Frequency of documented encounters.
    This is just the *study period* BEFORE selecting for suicidality DX

    :return: str suicide_icd10__count_study_period_month
    """
    view_name = table('count_study_period', duration)
    from_table = table('study_period')
    cols = [f'enc_start_{duration}',
            'period',
            'gender',
            'age_group',
            'race_display',
            'doc_ed_note',
            'enc_class_code',
            'doc_type_display']

    return counts.count_encounter(view_name, from_table, cols)

def concat_view_sql(create_view_list: List[str]) -> str:
    """
    :param create_view_list: SQL prepared statements
    :param filename: path to output file, default 'count.sql' in PWD
    """
    seperator = '-- ###########################################################'
    concat = list()

    for create_view in create_view_list:
        concat.append(seperator + '\n'+create_view + '\n')

    return '\n'.join(concat)

def write_view_sql(view_list_sql: List[str], filename='count.sql') -> None:
    """
    :param view_list_sql: SQL prepared statements
    :param filename: path to output file, default 'count.sql' in PWD
    """
    sql_optimizer = concat_view_sql(view_list_sql)
    sql_optimizer = sql_optimizer.replace("CREATE or replace VIEW", 'CREATE TABLE')
    sql_optimizer = sql_optimizer.replace('WHERE cnt_subject >= 10', 'WHERE cnt_subject >= 5')

    with open(filename, 'w') as fout:
        fout.write(sql_optimizer)


if __name__ == '__main__':
    write_view_sql([
        count_dx(),
        count_prevalence(),
        count_study_period()
    ])
