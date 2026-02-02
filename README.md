# aml-machine-learning-pipeline
End-to-end AML machine learning pipeline using SQL feature engineering, BigQuery Machine Learning, and Looker Studio dashboards for wallet risk scoring
# 🚀 End-to-End AML Machine Learning Pipeline

This project demonstrates an end-to-end **Anti–Money Laundering (AML) machine learning workflow**
using **SQL-based feature engineering**, **supervised machine learning with BigQuery ML**, and
**dashboard-driven risk analysis** in Looker Studio.

The goal is to identify potentially suspicious wallets based on transaction behavior patterns
and generate interpretable, model-driven risk signals.

## 🔄 Project Flow

1. Raw transaction data ingested into BigQuery
2. SQL-based feature engineering to extract AML risk signals
3. Signals combined into a wallet-level feature table
4. Supervised machine learning model (logistic regression) trained using labeled data
5. Model predictions generated for wallet risk scoring
6. Results visualized in Looker Studio dashboard

---

## 🔹 Architecture Overview

**Raw Data**
- Wallets
- Transactions
- Wallet-level attributes

⬇️

**SQL Feature Engineering**
- Dormant → Burst Activity Detection
- Spike vs Baseline Transaction Amounts
- High-Value Transaction Frequency
- High-Velocity Transaction Counts

⬇️

**Machine Learning**
- Supervised classification using **Logistic Regression (BigQuery ML)**
- Model trained on confirmed suspicious vs non-suspicious wallets
- Output includes predicted labels and risk indicators

⬇️

**Visualization**
- Looker Studio dashboard displaying:
  - Wallet-level risk signals
  - Model predictions
  - Aggregate suspicious wallet counts

---

## 🔹 Machine Learning Details

- **Model type:** Logistic Regression
- **Platform:** BigQuery ML
- **Features:** Derived entirely from SQL-based behavioral signals
- **Labels:** Confirmed suspicious vs non-suspicious wallets
- **Output:** Wallet-level predictions used for risk triage and monitoring

This approach emphasizes **interpretability, scalability, and production-ready ML workflows**
commonly used in financial crime and AML teams.

---

## 🔹 Technologies Used

- SQL (BigQuery)
- BigQuery ML
- Looker Studio
- Google Sheets (data staging)

---

## 🔮 Future Enhancements

- Add Python-based model evaluation (ROC-AUC, precision/recall)
- Experiment with additional ML models
- Automate daily wallet scoring and alerting
- Enhance dashboards with time-based monitoring

---

## 📊 Example Use Cases

- Identify wallets with sudden transaction bursts
- Flag wallets with abnormal value or velocity patterns
- Support AML investigations with model-driven risk scoring

## ⚠️ Data Disclaimer

All datasets used in this project are **synthetically generated** for educational
and demonstration purposes. The structure, distributions, and behavioral patterns
are designed to realistically simulate AML-relevant transaction activity while
containing **no real customer or financial data**.
