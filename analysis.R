# ECON418: Final Exam
# Author: Danny Watkins
# Date: Dec 12, 2024

# Load required libraries
if (!require("data.table")) install.packages("data.table", dependencies = TRUE)
if (!require("ggplot2")) install.packages("ggplot2", dependencies = TRUE)
if (!require("plm")) install.packages("plm", dependencies = TRUE)
if (!require("readr")) install.packages("readr", dependencies = TRUE)

library(data.table)
library(ggplot2)
library(plm)
library(readr)

# Step 1: Load the data
data <- fread("Desktop/ECON418 Final/ECON_418-518_Exam_3_Data.csv")

# Step 2: Explore the data
cat("\nStructure of the data:\n")
str(data)

cat("\nSummary of the data:\n")
summary(data)

# Step 3: Create post-treatment and state indicators
data[, time_period := ifelse(time_period %in% c("Feb", "February"), "Feb", "Nov")]
data[, post_treatment := ifelse(time_period == "Nov", 1, 0)]
data[, is_nj := ifelse(state == 1, 1, 0)]

# Step 4: Descriptive Statistics
mean_employment <- data[, .(mean_emp = mean(total_emp, na.rm = TRUE)), by = .(state, time_period)]
cat("\n(ii) Mean total employment by state and time period:\n")
print(mean_employment)

# Step 5: Difference-in-Differences Estimate by Sample Means
pre_nj <- data[state == 1 & time_period == "Feb", mean(total_emp, na.rm = TRUE)]
post_nj <- data[state == 1 & time_period == "Nov", mean(total_emp, na.rm = TRUE)]
pre_pa <- data[state == 0 & time_period == "Feb", mean(total_emp, na.rm = TRUE)]
post_pa <- data[state == 0 & time_period == "Nov", mean(total_emp, na.rm = TRUE)]

did_estimate <- (post_nj - pre_nj) - (post_pa - pre_pa)
cat("\n(iii) Difference-in-Differences estimate based on sample means:\n")
cat("DiD Estimate:", did_estimate, "\n")

# Visualization of DiD
ggplot(mean_employment, aes(x = time_period, y = mean_emp, group = state, color = factor(state))) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = "Difference-in-Differences Visualization",
       x = "Time Period",
       y = "Mean Employment",
       color = "State") +
  theme_minimal()

# Step 6: Estimate the DiD Model using lm()
model <- lm(total_emp ~ state + post_treatment + I(state * post_treatment), data = data)
summary_model <- summary(model)

# Extract ATT (state:post_treatment coefficient) and SE
did_coeff <- coef(summary_model)["I(state * post_treatment)", "Estimate"]
did_se <- coef(summary_model)["I(state * post_treatment)", "Std. Error"]

# Step 7: 95% Confidence Interval for ATT
alpha <- 0.05
critical_value <- qt(1 - alpha / 2, df = summary_model$df[2])
lower_bound <- did_coeff - critical_value * did_se
upper_bound <- did_coeff + critical_value * did_se

cat("\n(iv) 95% Confidence Interval for ATT:\n")
cat("Estimate:", did_coeff, "\n")
cat("95% CI: [", lower_bound, ",", upper_bound, "]\n")

# Step 8: Hypothesis Tests for ATT
# H0: ATT = 5, H1: ATT ≠ 5
t_stat_5 <- (did_coeff - 5) / did_se
p_value_5 <- 2 * (1 - pt(abs(t_stat_5), df = summary_model$df[2]))

# H0: ATT = 0, H1: ATT ≠ 0
t_stat_0 <- (did_coeff - 0) / did_se
p_value_0 <- 2 * (1 - pt(abs(t_stat_0), df = summary_model$df[2]))

cat("\nHypothesis Test for ATT = 5:\n")
cat("t-statistic:", t_stat_5, "p-value:", p_value_5, "\n")
if (p_value_5 < alpha) {
  cat("We reject the null hypothesis that ATT = 5 at the 5% significance level.\n")
} else {
  cat("We fail to reject the null hypothesis that ATT = 5 at the 5% significance level.\n")
}

cat("\nHypothesis Test for ATT = 0:\n")
cat("t-statistic:", t_stat_0, "p-value:", p_value_0, "\n")
if (p_value_0 < alpha) {
  cat("We reject the null hypothesis that ATT = 0 at the 5% significance level.\n")
} else {
  cat("We fail to reject the null hypothesis that ATT = 0 at the 5% significance level.\n")
}

# Step 9: Fixed Effects Model
pdata <- pdata.frame(data, index = c("restaurant_id", "time_period"))
fe_model <- plm(total_emp ~ state * post_treatment, data = pdata, model = "within")
cat("\n(vii) Fixed Effects Model Summary:\n")
summary(fe_model)


