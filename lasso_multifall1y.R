library(tidyverse)
library(glmnet)
library(pROC)

source("utils.R")

# Load data
ds <- read_csv("derived_data/ds_clean.csv") %>% select(-spid,-fallstat,-fallstat1y,-anyfall1y) 

# LASSO logistic regression
set.seed(2023)

## Split the dataset into training set and testing set
nrFolds <- 5
folds <- rep_len(1:nrFolds, nrow(ds))
fold <- which(folds==1)
train <- ds[-fold,]
test <- ds[fold,]

## Model specification
x_train <- model.matrix(~ . -1, data = train %>% select(-multifall1y))
x_test <- model.matrix(~ . -1, data = test %>% select(-multifall1y))
y_train <- train$multifall1y

## LASSO model
lasso_multifall1y <- cv.glmnet(x=x_train, y=y_train, alpha=1, family="binomial", nfolds = 10)
plot(lasso_multifall1y)
lasso_multifall1y.min <- glmnet(x=x_train, y=y_train, alpha=1, family="binomial", lambda=lasso_multifall1y$lambda.min)
coef(lasso_multifall1y.min)

test$multifall1y_pred_p <- predict(lasso_multifall1y.min, x_test, type="response") %>% as.numeric()
test$multifall1y_pred <- (test$multifall1y_pred_p > 0.5)*1
class_multifall1y <- test %>% group_by(multifall1y, multifall1y_pred) %>% tally()

## Calculate Sens, Spec, PPV, NPV
valid_multifall1y <- valid_measures(class_multifall1y)
valid_multifall1y %>% write_csv("derived_data/valid_multifall1y.csv")
print(valid_multifall1y)

## ROC using testing set
roc_multifall1y <- roc(test$multifall1y, test$multifall1y_pred_p)
auc(roc_multifall1y)

## Plot ROC curve
png("figures/figure5_roc_multifall1y.png", width = 400, height = 400)
plot(roc_multifall1y, main = "Figure 5. ROC Curve for multiple falls risk", col = "navy")
dev.off()
