# SQL Data Warehouse and Analytics Project

Welcome to my **Data Warehouse and Analytics Project**! 🚀  
This project demonstrates a comprehensive data warehousing solution, transforming raw data into actionable business insights using SQL. It highlights industry best practices in data engineering, modeling, and analytics.

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture** (Bronze, Silver, and Gold layers) to ensure data quality and scalability:

1. **Bronze Layer**: Stores raw data ingested directly from source systems (ERP and CRM CSV files) into the SQL database.
2. **Silver Layer**: Focuses on data cleansing, standardization, and normalization to prepare data for reliable analysis.
3. **Gold Layer**: Houses business-ready data modeled into a **Star Schema**, optimized for analytical queries and reporting.

---

## 📖 Project Overview

This project involves four main phases:

1. **Data Architecture**: Designing a modern warehouse using the Medallion approach.
2. **ETL Pipelines**: Extracting, transforming, and loading data through various layers using SQL scripts.
3. **Data Modeling**: Developing Fact and Dimension tables (Star Schema) for high-performance querying.
4. **Analytics & Reporting**: Generating SQL-based insights into customer behavior, product performance, and sales trends.

---

## 🛠️ Tech Stack & Tools

* **SQL Server**: For hosting the database and executing transformations.
* **SQL Server Management Studio (SSMS)**: For database management.
* **Draw.io**: For designing data models and architecture diagrams.
* **Notion**: For project management and tracking tasks.
* **GitHub**: For version control and project documentation.

---

## 🚀 Project Requirements & Objectives

### 1. Data Engineering
* **Integration**: Combine data from multiple sources (ERP & CRM).
* **Data Quality**: Solve quality issues like nulls, duplicates, and inconsistent formats.
* **Documentation**: Clear mapping of the data model for stakeholders.

### 2. Data Analytics
* **Insights**: Deliver detailed reports on Customer Behavior and Sales Trends.
* **Metrics**: Identify key business performance indicators (KPIs).

---

## 📂 Repository Structure

* `/datasets`: Raw ERP and CRM data files.
* `/scripts/bronze`: SQL scripts for raw data loading.
* `/scripts/silver`: SQL scripts for data cleaning and transformation.
* `/scripts/gold`: SQL scripts for building the Star Schema (Fact & Dimensions).
* `/docs`: Architecture diagrams and naming conventions.

---

## 👤 Author
**Abdelrahman Kotb** Biomedical Engineer & Aspiring Data Engineer  
[LinkedIn Profile](https://www.linkedin.com/in/abdulrahman-kotb-3b7466234/) | [GitHub Profile](https://github.com/abdulrhamankotb-cpu)

---

## 🛡️ License
This project is licensed under the MIT License.
