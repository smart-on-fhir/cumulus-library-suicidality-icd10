from typing import List
from cumulus_library.schema import counts

# https://github.com/smart-on-fhir/cumulus-library-template/issues/2
STUDY_PREFIX = 'suicide_icd10'

def table(tablename: str, duration=None) -> str:
    if duration:
        return f'{STUDY_PREFIX}__{tablename}_{duration}'
    else: 
        return f'{STUDY_PREFIX}__{tablename}'

def count_dx(duration='week'):
    """
    suicide_icd10__count_dx_week
    suicide_icd10__count_dx_month
    """
    view_name = table('count_dx', duration)
    from_table = table('dx')
    cols = [f'cond_{duration}',
            'dx_subtype',
            'dx_display',
            'doc_ed_note',
            'gender',
            'race_display',
            'age_at_visit',
            'enc_class_code',
            'doc_type_display']
    return counts.count_encounter(view_name, from_table, cols)

def count_study_period(duration='month'):
    """
    suicide_icd10__count_study_period_doc_week
    suicide_icd10__count_study_period_doc_month
    suicide_icd10__count_study_period_doc_year
    """
    view_name = table('count_study_period_doc', duration)
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
    with open(filename, 'w') as fout:
        fout.write(concat_view_sql(view_list_sql))


if __name__ == '__main__':

    write_view_sql([
        count_dx('week'),
        count_dx('month'),
        count_study_period('week'),
        count_study_period('month')
    ])
