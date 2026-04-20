# Load data
df <- read.csv("/Users/shivanimalik/Downloads/clin_for_new.csv", row.names = 1)  # Ensure row names are sample IDs
## imp to covert os time into months for kaplan curve
# Check structure
str(df)
head(df)
# Assuming your data frame is named df and has columns 'age' and 'OS_time'

# Remove rows with missing values
df_clean <- df[!is.na(df$age) & !is.na(df$OS_time), ]

# Perform correlation test
cor_result <- cor.test(df_clean$age, df_clean$OS_time, method = "pearson")

# Extract relevant values into a data frame
cor_df <- data.frame(
  Variable1 = "age",
  Variable2 = "OS_time",
  Correlation = cor_result$estimate,
  P_Value = cor_result$p.value,
  Method = cor_result$method
)

# Save to CSV
write.csv(cor_df, "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/correlation_result_age_os_time.csv", row.names = FALSE)

# Load survival package
library(survival)

# Assuming vital_status: 1 = dead, 0 = alive if not then
# Step 1: Convert vital_status to 0 (Living) and 1 (Deceased)
df$vital_status <- tolower(df$vital_status)  # Convert to lowercase for safety

df$vital_status <- ifelse(df$vital_status == "deceased", 1,
                          ifelse(df$vital_status == "living", 0, NA))

# and OS_time is in days or months
# Make sure there are no missing values
cox_data <- df[!is.na(df$age) & !is.na(df$OS_time) & !is.na(df$vital_status), ]

# Build the survival object
surv_obj <- Surv(time = cox_data$OS_time, event = cox_data$vital_status)

# Fit Cox model with age as the predictor
cox_model <- coxph(surv_obj ~ age, data = cox_data)

# Show model summary (includes HR, CI, and p-value)
summary(cox_model)
# Get the summary of the Cox model
cox_summary <- summary(cox_model)

# Extract key values
hr_table <- data.frame(
  Variable = rownames(cox_summary$coefficients),
  Coefficient = cox_summary$coefficients[, "coef"],
  Hazard_Ratio = cox_summary$coefficients[, "exp(coef)"],
  SE = cox_summary$coefficients[, "se(coef)"],
  Z_value = cox_summary$coefficients[, "z"],
  P_value = cox_summary$coefficients[, "Pr(>|z|)"],
  CI_lower = cox_summary$conf.int[, "lower .95"],
  CI_upper = cox_summary$conf.int[, "upper .95"]
)

# Save to CSV
write.csv(hr_table, "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/cox_regression_results_age_OS_time.csv", row.names = FALSE)
## box plot

library(ggplot2)

# Create the plot
ggplot(df, aes(x = age, y = OS_time)) +
  geom_point(aes(color = age), alpha = 0.6, size = 2) +  # Gradient color by age
  geom_smooth(method = "lm", se = TRUE, color = "#D55E00", size = 1.2, linetype = "solid") +  # Trend line
  scale_color_gradient(low = "#56B1F7", high = "#132B43") +  # Color gradient
  labs(
    x = "Age (years)",
    y = "Overall Survival Time (months)",
    #title = "Age vs Overall Survival Time",
    #subtitle = "Linear trend with confidence interval",
    #caption = "Data Source: TCGA"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 13, hjust = 0.5),
    plot.caption = element_text(size = 10, hjust = 1),
    axis.title = element_text(face = "bold"),
    legend.position = "none"
  )
##kapln curve 
library(survival)
library(survminer)
# Convert OS_time from days to months
df$OS_time_months <- df$OS_time / 30.44

# Create Age Group based on median
df$age_group <- ifelse(df$age > median(df$age, na.rm = TRUE), "Older", "Younger")

# Build survival object using months
surv_obj <- Surv(time = df$OS_time_months, event = df$vital_status)

# Fit KM model
fit_age <- survfit(surv_obj ~ age_group, data = df)
# KM Plot with improved time scaling
ggsurvplot(
  fit_age,
  data = df,
  pval = TRUE,
  pval.coord = c(12, 0.2),                   # Adjust to match month scale
  conf.int = TRUE,
  risk.table = TRUE,
  risk.table.height = 0.3,
  risk.table.fontsize = 4,
  font.tickslab = 12,
  font.x = 14,
  font.y = 14,
  font.title = 14,
  font.subtitle = 12,
  font.caption = 12,
  font.legend = 12,
  legend.title = "Age Group",
  legend.labs = c("Older", "Younger"),
  break.time.by = 50,                        # X-axis breaks every 12 months
  xlab = "Time (months)",
  ylab = "Survival Probability",
  title = "Kaplan-Meier Survival Curve by Age Group",
  palette = c("#E69F00", "#56B4E9"),         # Orange and blue palette
  risk.table.y.text = TRUE,
  risk.table.y.text.col = TRUE,
  ggtheme = theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5),
      legend.position = "top",
      axis.title = element_text(face = "bold"),
      strip.text = element_text(face = "bold")
    )
)



## now for gender #
## correlation for gender##
# Convert gender to numeric: male = 1, female = 0 (or vice versa)
df$gender_numeric <- ifelse(tolower(df$gender) == "male", 1,
                            ifelse(tolower(df$gender) == "female", 0, NA))

# Remove rows with missing values in gender or OS_time
df_gender_clean <- df[!is.na(df$gender_numeric) & !is.na(df$OS_time), ]

# Perform Pearson correlation
cor_gender <- cor.test(df_gender_clean$gender_numeric, df_gender_clean$OS_time, method = "pearson")

# Save correlation result
cor_gender_df <- data.frame(
  Variable1 = "gender (male=1, female=0)",
  Variable2 = "OS_time",
  Correlation = cor_gender$estimate,
  P_Value = cor_gender$p.value,
  Method = cor_gender$method
)

write.csv(cor_gender_df, "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/correlation_result_gender_os_time.csv", row.names = FALSE)

## survival for gender##

# Load required package
library(survival)

# Ensure gender is numeric: 0 = Female, 1 = Male
df_gender_clean$vital_status <- tolower(df_gender_clean$vital_status)  # Convert to lowercase for safety

df_gender_clean$vital_status <- ifelse(df_gender_clean$vital_status == "deceased", 1,
                          ifelse(df_gender_clean$vital_status == "living", 0, NA))

# Create survival object
surv_gender_obj <- Surv(time = df_gender_clean$OS_time, event = df_gender_clean$vital_status)

# Fit Cox proportional hazards model
cox_gender_model <- coxph(surv_gender_obj ~ gender_numeric, data = df_gender_clean)

# Summary of the model
cox_gender_summary <- summary(cox_gender_model)

# Format HR table
gender_hr_table <- data.frame(
  Variable = rownames(cox_gender_summary$coefficients),
  Coefficient = cox_gender_summary$coefficients[, "coef"],
  Hazard_Ratio = cox_gender_summary$coefficients[, "exp(coef)"],
  SE = cox_gender_summary$coefficients[, "se(coef)"],
  Z_value = cox_gender_summary$coefficients[, "z"],
  P_value = cox_gender_summary$coefficients[, "Pr(>|z|)"],
  CI_lower = cox_gender_summary$conf.int[, "lower .95"],
  CI_upper = cox_gender_summary$conf.int[, "upper .95"]
)
print(gender_hr_table)

# Optionally, save to CSV
write.csv(gender_hr_table, "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/cox_gender_hr_results.csv", row.names = FALSE)
# Load required libraries
library(survival)
library(survminer)

# Step 1: Remove rows with missing gender, OS_time, or vital_status
df_gender <- df[!is.na(df$gender) & !is.na(df$OS_time_months) & !is.na(df$vital_status), ]
# Make sure it's all uppercase or lowercase to match values
df_gender$vital_status <- toupper(df_gender$vital_status)

# Convert to numeric: 1 = Deceased, 0 = Living
df_gender$vital_status <- ifelse(df_gender$vital_status == "DECEASED", 1,
                                 ifelse(df_gender$vital_status == "LIVING", 0, NA))
# Convert gender to numeric: male = 1, female = 0 (or vice versa)
df$gender_numeric <- ifelse(tolower(df$gender) == "male", 1,
                            ifelse(tolower(df$gender) == "female", 0, NA))
# Step 2: Create survival object
surv_obj_gender <- Surv(time = df_gender$OS_time_months, event = df_gender$vital_status)

# Step 3: Fit Kaplan-Meier model by gender
fit_gender <- survfit(surv_obj_gender ~ gender, data = df_gender)

# Step 6: Plot the KM curve
ggsurvplot(
  fit_gender,
  data = df_gender,
  pval = TRUE,
  pval.coord = c(100, 0.2),  # adjust as needed
  conf.int = TRUE,
  risk.table = TRUE,
  risk.table.height = 0.3,
  risk.table.fontsize = 4,
  font.tickslab = 12,
  font.x = 14,
  font.y = 14,
  font.title = 14,
  font.subtitle = 12,
  font.caption = 12,
  font.legend = 12,
  legend.title = "Gender",
  legend.labs = c("Female", "Male"),  # Correctly matching encoding
  break.time.by = 50,
  xlab = "Time (months)",
  ylab = "Survival Probability",
  palette = c("#E69F00", "#56B4E9"),  # Yellow = Female, Blue = Male
  risk.table.y.text = TRUE,
  risk.table.y.text.col = TRUE,
  ggtheme = theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.4),
      legend.position = "top",
      axis.title = element_text(face = "bold"),
      strip.text = element_text(face = "bold")
    )
)
table(df_gender$gender_factor)
## Now for stage ##
# Load data

# Ensure stage and OS_time columns exist
head(df$stage)
head(df$OS_time)

# Convert stage to numeric values
df$stage_numeric <- ifelse(df$stage == "Stage I", 0,
                           ifelse(df$stage == "Stage II", 1,
                                  ifelse(df$stage == "Stage III", 2,
                                         ifelse(df$stage %in% c("Stage IV", "Stage IVA", "Stage IVC"), 3, NA))))

# Remove rows with missing stage or OS_time
df_clean_stage <- df[!is.na(df$stage_numeric) & !is.na(df$OS_time), ]

# Perform Pearson correlation test
cor_result_stage <- cor.test(df_clean_stage$stage_numeric, df_clean_stage$OS_time, method = "pearson")

# Create a result data frame
cor_stage_df <- data.frame(
  Variable1 = "stage_numeric",
  Variable2 = "OS_time",
  Correlation = cor_result_stage$estimate,
  P_Value = cor_result_stage$p.value,
  Method = cor_result_stage$method
)

# View the result
print(cor_stage_df)

# Save result to CSV
write.csv(cor_stage_df, "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/correlation_stage_os_time.csv", row.names = FALSE)
## spearman
# Step 1: Map stage to numeric
# Step 2: Remove missing values
# Step 3: Perform Spearman correlation
# -----------------------------
cor_result_spearman <- cor.test(df_clean_stage$stage_numeric,
                                df_clean_stage$OS_time,
                                method = "spearman")

# -----------------------------
# Step 4: Create result dataframe
# -----------------------------
cor_df_spearman <- data.frame(
  Variable1 = "stage_numeric",
  Variable2 = "OS_time",
  Correlation = cor_result_spearman$estimate,
  P_Value = cor_result_spearman$p.value,
  Method = cor_result_spearman$method
)

# Print and check result
print(cor_df_spearman)

# -----------------------------
# Step 5: Save result to CSV
# -----------------------------
write.csv(cor_df_spearman,
          "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/correlation_spearman_stage_os_time.csv",
          row.names = FALSE)
## survival ##
# Load required package
library(survival)


# Step 2: Clean the data - remove NAs
df_clean_stage <- df[!is.na(df$stage_numeric) & !is.na(df$OS_time_months) & !is.na(df$vital_status), ]

# Step 3: Convert vital_status to numeric if not already
df_clean_stage$vital_status <- ifelse(tolower(df_clean_stage$vital_status) == "deceased", 1,
                                      ifelse(tolower(df_clean_stage$vital_status) == "living", 0, NA))

# Step 4: Create survival object
surv_obj_stage <- Surv(time = df_clean_stage$OS_time_months, event = df_clean_stage$vital_status)

# Step 5: Fit Cox model using stage_numeric
cox_model_stage <- coxph(surv_obj_stage ~ stage_numeric, data = df_clean_stage)

# Step 6: Summarize the model
summary_stage <- summary(cox_model_stage)

# Step 7: Extract results into a table
stage_hr_table <- data.frame(
  Variable = "Stage",
  Coefficient = summary_stage$coefficients[, "coef"],
  Hazard_Ratio = summary_stage$coefficients[, "exp(coef)"],
  SE = summary_stage$coefficients[, "se(coef)"],
  Z_value = summary_stage$coefficients[, "z"],
  P_value = summary_stage$coefficients[, "Pr(>|z|)"],
  CI_lower = summary_stage$conf.int[, "lower .95"],
  CI_upper = summary_stage$conf.int[, "upper .95"]
)

# Step 8: View results
print(stage_hr_table)

# Optionally, save the results to a CSV
write.csv(stage_hr_table, "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/cox_stage_hr_results.csv", row.names = FALSE)

## kaplan curve ##
# Load libraries
library(survival)
library(survminer)
# Step 5: Fit KM model by stage
fit_stage <- survfit(surv_obj_stage ~ as.factor(stage_numeric), data = df_clean_stage)
# Plot with better risk table
ggsurvplot(
  fit_stage,
  data = df_clean_stage,
  pval = TRUE,
  pval.coord = c(100, 0.2),
  conf.int = TRUE,
  break.time.by = 50,
  xlab = "Time (months)",
  ylab = "Survival Probability",
  legend.title = "Stage",
  legend.labs = c("I", "II", "III", "IV"),
  palette = c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3"),
  
  # Fix risk table
  risk.table = TRUE,
  risk.table.title = "Number at risk",
  risk.table.height = 0.35,
  risk.table.fontsize = 3.5,
  risk.table.y.text = FALSE,  # disable overlapping colored text
  
  # Add better y-labels for risk table
  tables.theme = theme(
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title.y = element_text(size = 12, face = "bold")
  ),
  
  ggtheme = theme_minimal(base_size = 14) +
    theme(
      plot.title = element_blank(),
      axis.title = element_text(face = "bold"),
      legend.position = "top"
    )
)
## done ##
## multivariate 
# Load required libraries
library(survival)
library(survminer)

# Filter out missing data
df_multi <- df[!is.na(df$OS_time) & !is.na(df$vital_status) &
                 !is.na(df$age) & !is.na(df$gender_numeric) &
                 !is.na(df$stage_numeric), ]

# Create a survival object
surv_obj <- Surv(time = df_multi$OS_time, event = df_multi$vital_status)

# Fit the multivariate Cox model
cox_multi_model <- coxph(surv_obj ~ age + gender_numeric + stage_numeric, data = df_multi)

# Display summary
summary(cox_multi_model)
cox_sum <- summary(cox_multi_model)
multi_hr_table <- data.frame(
  Variable = rownames(cox_sum$coefficients),
  Coefficient = cox_sum$coefficients[, "coef"],
  Hazard_Ratio = cox_sum$coefficients[, "exp(coef)"],
  SE = cox_sum$coefficients[, "se(coef)"],
  Z_value = cox_sum$coefficients[, "z"],
  P_value = cox_sum$coefficients[, "Pr(>|z|)"],
  CI_lower = cox_sum$conf.int[, "lower .95"],
  CI_upper = cox_sum$conf.int[, "upper .95"]
)

write.csv(multi_hr_table, "/Users/shivanimalik/Documents/Thyroid_cancer_dataset/cox_multivariate_results.csv", row.names = FALSE)
# Add label for plot (with p-value shown)
multi_hr_table$Variable_label <- paste0(
  multi_hr_table$Variable,
  " (p = ", formatC(multi_hr_table$P_value, format = "e", digits = 2), ")"
)

# Reverse the order for ggplot
multi_hr_table$Variable_label <- factor(
  multi_hr_table$Variable_label,
  levels = rev(multi_hr_table$Variable_label)
)
library(ggplot2)

ggplot(multi_hr_table, aes(x = Hazard_Ratio, y = Variable_label)) +
  geom_point(color = "red", size = 4) +
  geom_errorbarh(aes(xmin = CI_lower, xmax = CI_upper), height = 0.25, color = "blue") +
  geom_vline(xintercept = 1, linetype = "dashed", color = "gray50") +
  scale_x_continuous(trans = "log10") +
  labs(
   # title = "Forest Plot of Multivariate Cox Regression",
    x = "Hazard Ratio (95% CI)",
    y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.text.y = element_text(face = "bold")
  )



