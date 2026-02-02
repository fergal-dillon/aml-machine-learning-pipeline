-- =====================================================
-- AML Feature Engineering: Behavioral Risk Signals
-- =====================================================
-- Purpose:
-- Generate wallet-level behavioral features from
-- raw transaction data for AML risk detection.
--
-- Signals included:
-- 1. Dormant → Burst Activity
-- 2. Spike vs Baseline Transaction Amounts
-- 3. High-Value Transactions
-- 4. High-Velocity Transactions
-- =====================================================


-- -----------------------------------------------------
-- Signal 1: Dormant → Burst Activity
-- -----------------------------------------------------
-- Description:
-- Identifies wallets that were inactive for a period
-- and then suddenly show a burst of transaction activity.

--

WITH last_tx AS (
  SELECT 
    wallet_id,
    MAX(tx_time) AS most_recent_tx
  FROM `aml-sql-ml-dashboard.aml_dataset.transactions`
  GROUP BY wallet_id
),
txns_7day_spike AS (
  SELECT 
    wallet_id,
    COUNT(*) AS txns_in_7day,
    SUM(amount) AS amt_in_7day,
    MIN(tx_time) AS first_tx_in_7day,
    MAX(tx_time) AS last_tx_in_7day
  FROM `aml-sql-ml-dashboard.aml_dataset.transactions`
  WHERE tx_time >= DATE_SUB((SELECT MAX(tx_time) FROM `aml-sql-ml-dashboard.aml_dataset.transactions`), INTERVAL 7 DAY)
  GROUP BY wallet_id
)
SELECT
  l.wallet_id,
  l.most_recent_tx,
  t.txns_in_7day,
  t.amt_in_7day,
  t.first_tx_in_7day,
  t.last_tx_in_7day
FROM last_tx l
JOIN txns_7day_spike t
USING(wallet_id)
WHERE t.txns_in_7day >= 3

-- -----------------------------------------------------
-- Signal 2: Spike vs Baseline Amount Ratio
-- -----------------------------------------------------
-- Description:
-- Compares recent transaction amounts to historical
-- baseline behavior to detect abnormal spikes.

-- 
  
WITH wallet_tx AS (
  SELECT
    wallet_id,
    tx_time,
    amount,
    ROW_NUMBER() OVER (PARTITION BY wallet_id ORDER BY tx_time DESC) AS rn_desc
  FROM `aml-sql-ml-dashboard.aml_dataset.transactions`
),
-- Spike window: last 3 transactions per wallet
spike AS (
  SELECT 
    wallet_id, 
    SUM(amount) AS sum_spike
  FROM wallet_tx
  WHERE rn_desc <= 3
  GROUP BY wallet_id
),
-- Baseline window: all other transactions
baseline AS (
  SELECT 
    wallet_id, 
    AVG(amount) AS avg_baseline
  FROM wallet_tx
  WHERE rn_desc > 3
  GROUP BY wallet_id
)
SELECT
  s.wallet_id,
  s.sum_spike,
  b.avg_baseline,
  SAFE_DIVIDE(s.sum_spike, b.avg_baseline) AS spike_ratio
FROM spike s
JOIN baseline b
USING(wallet_id)
WHERE SAFE_DIVIDE(s.sum_spike, b.avg_baseline) >= 2;  -- adjust threshold as needed


-- -----------------------------------------------------
-- Signal 3: High-Value Transactions
-- -----------------------------------------------------
-- Description:
-- Flags wallets with unusually large transaction amounts.

-- 🔽 

SELECT
  wallet_id,
  MAX(amount) AS max_tx_amount,
  COUNTIF(amount >= 1000) AS num_high_tx
FROM `aml-sql-ml-dashboard.aml_dataset.transactions`
GROUP BY wallet_id
HAVING num_high_tx > 0;

-- -----------------------------------------------------
-- Signal 4: High-Velocity Transactions
-- -----------------------------------------------------
-- Description:
-- Identifies wallets with rapid transaction frequency
-- within a short time window.

-- 🔽

WITH wallet_tx AS (
  SELECT
    wallet_id,
    tx_time
  FROM `aml-sql-ml-dashboard.aml_dataset.transactions`
),
last_tx AS (
  SELECT MAX(tx_time) AS max_tx_time
  FROM wallet_tx
),
tx_counts AS (
  SELECT
    wallet_id,
    COUNT(*) AS txn_count_last_7d
  FROM wallet_tx, last_tx
  WHERE tx_time >= DATE_SUB(max_tx_time, INTERVAL 7 DAY)
  GROUP BY wallet_id
)
SELECT *
FROM tx_counts
WHERE txn_count_last_7d >= 3  -- threshold for “high velocity”, adjust as needed
ORDER BY txn_count_last_7d DESC;
