import unittest

fin_csv = '/opt/labelstudio/suicide-icd10/2024-june5/chart_review_ids.csv'
fout_sql = '/opt/labelstudio/suicide-icd10/2024-june5/chart_review_ids.sql'

CTAS_START = """ 
create or replace view suicide_icd10__define_chart_ids 
as select * from (VALUES
"""

CTAS_STOP = ") \n AS t (chart_id, original_fhir_id, anonymized_fhir_id)"

class TestMyChartReviewIdsToSQL(unittest.TestCase):

    def test(self):
        out = list()
        with open(fin_csv, 'r') as fp:
            lines = fp.readlines()

        for row in lines:
            chart_id, fhir_orig, fhir_anon = row.strip().split(',')
            if not chart_id == 'chart_id':
                out.append(f"({chart_id}, '{fhir_orig}', '{fhir_anon}')")

        out = CTAS_START + '\n,'.join(out) + CTAS_STOP
        with open(fout_sql, 'w') as fp:
            fp.writelines(out)

    def test_chisquare(self):
        import numpy as np
        from scipy.stats import chi2_contingency


if __name__ == '__main__':
    unittest.main()
