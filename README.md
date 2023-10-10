# BodyFatPrediction
A simple, robust, and accurate model to estimate percentage of body fat using clinically available measurement.


From Yu Luan:
Formulate the model in R:
Choose and revise model:
1. Exploratory Data Analysis (EDA): Checked the distribution of the target variable (Body Fat) which roughly followed a normal distribution, So choose Linear regression as our model.
2. Feature Correlation Analysis: Used Pearson correlation to determine the strength and direction of the linear relationship between predictors and body fat percentage.
3. Multicollinearity Check: Used the Variance Inflation Factor (VIF) to check for multicollinearity among predictors.

Model Development:
1.Split the data into training and testing sets.
2.Fitted a full linear regression model using all predictors.
3. Iteratively refined the model based on VIF values and correlation strength to select a subset of predictors for a reduced model.

Model Performance:

Full Model RMSE: 4.152944
Reduced Model RMSE: 4.584275
