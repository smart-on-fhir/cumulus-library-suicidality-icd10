# How reliable are ICD-10 diagnosis codes to identify cases of pediatric suicidality?

This study repository includes:

* **Suicidality ICD10 case definition** (SQL on FHIR) 
* [Propensity Score Matching](https://github.com/smart-on-fhir/cumulus-library/blob/main/tests/test_psm.py) (PSM) to select "case matched comparators"
* [Chart Review](https://docs.smarthealthit.org/cumulus/chart-review/) software for reproducing results
* **Supplement**   
  1. Suicidality ICD10 Case Definition (XLS/TSV)
  2. Propensity Score Matching (Word/PDF)
  3. Suicidality Chart Review Guidelines (Word/PDF)
  4. Additional Statistical Measures (Word/PDF)

All patient data and were made available by [Cumulus](https://smarthealthit.org/cumulus-a-universal-sidecar-for-a-smart-learning-healthcare-system/) at Boston Children's Hospital.

For more information, [browse the Cumulus library documentation](https://docs.smarthealthit.org/cumulus/library).

## Usage

To install the module, run `git clone git@github.com:smart-on-fhir/cumulus-library-suicidality-icd10.git`.

To install the module, run `pip install -e .`.

This will add a `cumulus-library-suicidality-icd10` study target to `cumulus-library`.

## Publication

__Accuracy of ICD-10 codes for suicidal ideation and action in pediatric emergency department encounters__
Rena Xu, Louisa Bode, Alon Geva, Kenneth D. Mandl, Andrew J. McMurry. Pediatrics. 2024. 
https://doi.org/10.1101/2024.07.23.24310777