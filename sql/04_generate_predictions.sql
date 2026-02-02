-- =====================================================
-- AML Wallet Risk Prediction
-- =====================================================
-- Purpose:
-- Apply the trained ML model to score wallets and
-- generate risk predictions for analysis and dashboards.
--
-- Output:
-- Wallet-level predictions with risk indicators.
-- =====================================================


-- -----------------------------------------------------
-- Generate Predictions
-- -----------------------------------------------------
-- Description:
-- Uses ML.PREDICT to assign suspicious labels
-- to each wallet.

-- 🔽 

CREATE OR REPLACE TABLE `aml-sql-ml-dashboard.aml_dataset.wallet_predictions` AS
SELECT
  c.wallet_id,
  c.dormant_burst_txns_in_7day,
  c.dormant_burst_amt_in_7day,
  c.spike_sum_last3,
  c.spike_avg_baseline,
  c.spike_ratio,
  c.high_value_max_tx,
  c.high_value_count,
  c.high_velocity_txns_last7d,
  p.predicted_label AS predicted_label,
  p.predicted_label_probs[SAFE_OFFSET(1)] AS prob_suspicious
FROM `aml-sql-ml-dashboard.aml_dataset.AML_SIGNAL_COMBINED` c
JOIN ML.PREDICT(MODEL `aml-sql-ml-dashboard.aml_dataset.wallet_model`,
                (SELECT * FROM `aml-sql-ml-dashboard.aml_dataset.AML_SIGNAL_COMBINED`)) AS p
USING(wallet_id);
