-- =====================================================
-- AML Signal Combination
-- =====================================================
-- Purpose:
-- Combine all engineered AML signals into a single
-- wallet-level feature table to be used for modeling.
--
-- Output:
-- One row per wallet with all risk indicators.
-- =====================================================


-- -----------------------------------------------------
-- Combine Feature Tables
-- -----------------------------------------------------
-- Description:
-- Joins all individual signal tables on wallet_id.

-- 🔽

SELECT
  w.wallet_id,
  COALESCE(d.txns_in_7day, 0) AS dormant_burst_txns_in_7day,
  COALESCE(d.amt_in_7day, 0) AS dormant_burst_amt_in_7day,
  COALESCE(s.sum_spike, 0) AS spike_sum_last3,
  COALESCE(s.avg_baseline, 0) AS spike_avg_baseline,
  COALESCE(s.spike_ratio, 0) AS spike_ratio,
  COALESCE(h.max_tx_amount, 0) AS high_value_max_tx,
  COALESCE(h.num_high_tx, 0) AS high_value_count,
  COALESCE(v.txn_count_last_7d, 0) AS high_velocity_txns_last7d
FROM `aml-sql-ml-dashboard.aml_dataset.wallets` w
LEFT JOIN `aml-sql-ml-dashboard.aml_dataset.AML_SIGNAL_1_DORMANT_TO_BURST` d
  USING(wallet_id)
LEFT JOIN `aml-sql-ml-dashboard.aml_dataset.AML_SIGNAL_2_SPIKE_VS_BASELINE` s
  USING(wallet_id)
LEFT JOIN `aml-sql-ml-dashboard.aml_dataset.AML_SIGNAL_3_HIGH_VALUE_TX` h
  USING(wallet_id)
LEFT JOIN `aml-sql-ml-dashboard.aml_dataset.AML_SIGNAL_4_HIGH_VELOCITY` v
  USING(wallet_id);
