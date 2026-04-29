🧬 Integrative Bioinformatics Approach for Identifying Prognostic Gene Sets in Thyroid Carcinoma Risk Stratification
This repository contains scripts, data references, and results for identifying prognostic gene sets in thyroid carcinoma (THCA) using machine learning and statistical analysis.
DOI: 10.64898/2026.04.23.720344

🔍 Overview
Data Source: Gene expression dataset (n = 572) with associated survival information
Preprocessing: Log2 normalization and standard scaling were applied to the data
Survival Classes: Overall survival (OS) time was categorized into four groups:
0–1 years
1–3 years
3–5 years

5 years

Feature Selection: Applied multiple methods including:
SVC-L1 (Support Vector Classifier with L1 regularization)
RFE (Recursive Feature Elimination)
SelectKBest
Class Imbalance Handling: SMOTE was used to balance survival classes
Modeling: Built and evaluated multiple machine learning and ensemble models for survival classification
Performance:
Biomarker-based models achieved AUC values ranging from 0.91 to 0.94
Ensemble models achieved an AUC of 0.95 on test data
Incorporating clinical features (stage, age, gender) improved performance to AUC = 0.96
📁 Repository Structure
📂 1. Biomarkers/

Contains gene sets selected using the SVC-L1 feature selection technique.

📂 Primary_biomarker/
List_1st_set.txt — First set of 20 genes
List_2nd_set.txt — Second set of 20 genes
List_3rd_set.txt — Third set of 20 genes
List_4th_set.txt — Fourth set of 20 genes
List_5th_set.txt — Fifth set of 20 genes
List_6th_set.txt — Sixth set of 20 genes
List_7th_set.txt — Seventh set of 20 genes

Usage: These gene sets were evaluated to identify the most robust prognostic biomarkers.

📂 2. Dataset/
📂 Link/
Data_link.txt — Contains links to data sources such as TCGA portal and UCSC Xena Browser

Usage: Provides access to raw datasets used for analysis and reproducibility.

📂 3. Scripts/
thyroid_cancer_preprocessing.py
Performs preprocessing steps including removal of features with >50% zero values, low variance filtering, and normalization.
Usage: Generates a clean and normalized dataset for downstream analysis.
feature_selection_ML.py
Applies SVC-L1 for feature selection, identifies top 20 genes, builds machine learning models, and evaluates performance.
Usage: Core pipeline for biomarker selection and model development.
ml_clinical_1st_20.py
Performs preprocessing, integrates clinical features, applies machine learning models, and evaluates performance.
Usage: Used to assess the impact of clinical features on model performance.

📊 TCGA THCA Dataset Description
Data from The Cancer Genome Atlas Thyroid Carcinoma (THCA) cohort was used in this study.

📁 THCA_Dataset_ALL/
This folder contains all processed datasets used for analysis, feature selection, and machine learning modeling.

📂 Gene_expression_data/
🧬 TCGA_THCA.csv
Contains raw gene expression data for all samples.
Usage: Used as the initial dataset for preprocessing, normalization, and feature selection.

📊 Z_scale_THCA_data_1.csv
Final processed dataset after preprocessing and Z-score scaling.
Usage: Used as the primary input for downstream analysis, including feature selection and machine learning model development.

📂 Clinical_data/
🏥 imp_clinical.csv
Contains important clinical variables used in the study (e.g., age, gender, stage, survival information).
Usage: Used to integrate clinical features with gene expression data and improve model performance.

📂 Gene Signature Folders
The THCA_Dataset_ALL/ directory also includes seven folders representing different gene signature sets:

First/
Second/
Third/
Fourth/
Fifth/
Sixth/
Seventh/

Each folder contains:
Training and testing datasets
Expression values of 20 selected genes (identified through feature selection methods such as SVC-L1)
Usage:
Used to evaluate and compare multiple gene signatures to identify the most robust prognostic model.

All the data files are available in the THCA_Dataset_ALL folder, which includes the train and test datasets for all seven biomarker sets.\
They can be downloaded from the following Google Drive link:

<https://drive.google.com/drive/folders/1n1Q9qwCu8O2q7cd3WTJRKiP8Nfx0yFE3?usp=drive_link>
