-- =====================================================
-- AML Machine Learning Model Training
-- =====================================================
-- Purpose:
-- Train a supervised machine learning model to classify
-- wallets as suspicious or non-suspicious.
--
-- Model:
-- Logistic Regression (BigQuery ML)
--
-- Labels:
-- Confirmed suspicious vs non-suspicious wallets
-- =====================================================


-- -----------------------------------------------------
-- Train Logistic Regression Model
-- -----------------------------------------------------
-- Description:
-- Uses engineered SQL features and known labels
-- to learn behavioral risk patterns.

-- 🔽 

CREATE OR REPLACE MODEL `aml-sql-ml-dashboard.aml_dataset.wallet_model`
OPTIONS(
  model_type = 'logistic_reg',
  input_label_cols = ['label']
) AS
SELECT
  c.*,
  l.label
FROM `aml-sql-ml-dashboard.aml_dataset.AML_SIGNAL_COMBINED` c
JOIN `aml-sql-ml-dashboard.aml_dataset.labels` l
USING(wallet_id);
