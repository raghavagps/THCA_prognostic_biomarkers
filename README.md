\# 🧬 Integrative Bioinformatics Approach for Identifying Prognostic
Gene Sets in Thyroid Carcinoma Risk Stratification

This repository contains all scripts, data references, and results
related to the identification of prognostic gene sets in \*\*thyroid
carcinoma (THCA)\*\* using machine learning and statistical analysis.

\-\--

\## 🔍 Overview

\- \*\*Data Source\*\*: Gene expression data (n = 572) with survival
information

\- \*\*Normalization & scaling\*\*: log2 normalization and standard
scalcar used for scaling.

\- \*\*Survival Classes\*\*: Overall survival time (OS) was categorized
into four classes: 0--1, 1--3, 3--5, and \>5 years (Classes 0 to 3).

\- \*\*Feature Selection\*\*: Employed SVC-L1, RFE and SelectKBest to
extract top prognostic features.

\- \*\*Class Imbalance Handling\*\*: Used SMOTE to address imbalance
across survival classes.

\- \*\*Modeling\*\*: Built and evaluated ML and ensemble machine
learning models to classify survival groups.

\- \*\*Performance\*\*: AUCs across biomarker sets ranged from 0.91 to
0.94 and ensemble model AUC of 0.95 on test data supporting robustness
and reproducibility.
\- \*\*Performance of first set along with clinical features \*\*: AUCs achieved 0.96 on test data after incorporating stage, age and gender. 


\## 📁 Repository Structure

\### 1. \`Biomarkers/\`

Contains gene sets selected using SVC-L1 feature selection technique.

\- \`Primary_biomarker/\`

\- \`List_1st_set.txt\` -- First set of 20 genes

\- \`List_2nd_set.txt\` -- Second set of 20 genes

\- \`List_3rd_set.txt\` -- Third set of 20 genes

\- \`List_4th_set.txt\` -- Fourth set of 20 genes

\- \`List_5th_set.txt\` -- Fifth set of 20 genes

\- \`List_6th_set.txt\` -- Sixth set of 20 genes

\- \`List_7th_set.txt\` -- Seventh set of 20 genes

\-\--

\### 2. \`Dataset/\`

\#### \`Link/\`

\- \`Data_link.txt\` -- Contains TCGA portal and UCSC Xena browser links
for direct data access.

\-\--

\### 3. \`Scripts/\`

\- \`thyroid_cancer_preprocessing.py\` -- Removal of 50% Zeroes and low
variance features and normalize the data.

\- \`feature_selection_ML.py\` -- Applies SVC-L1 and select top 20
features on the basis of ranking, builds ML classifiers, and evaluates
model.
\- \`ml_clinical_1st_20.py\` -- preprocessing, Apply ML classifiers, and evaluate. 


All the data files are available in the THCA_Dataset_ALL folder, which
includes the train and test datasets for all seven biomarker sets.\
They can be downloaded from the following Google Drive link:

<https://drive.google.com/drive/folders/1n1Q9qwCu8O2q7cd3WTJRKiP8Nfx0yFE3?usp=drive_link>
