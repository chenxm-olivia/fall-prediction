library(tidyverse)
library(glmnet)
library(pROC)

source("utils.R")

# Load data
ds <- read_csv("derived_data/ds_clean.csv") %>% select(-spid,-fallstat,-fallstat1y,-multifall1y) 

# LASSO logistic regression
set.seed(2023)

## Split the dataset into training set and testing set
nrFolds <- 5
folds <- rep_len(1:nrFolds, nrow(ds))
fold <- which(folds==1)
train <- ds[-fold,]
test <- ds[fold,]

## Model specification
x_train <- model.matrix(~ . -1, data = train %>% select(-anyfall1y))
x_test <- model.matrix(~ . -1, data = test %>% select(-anyfall1y))
y_train <- train$anyfall1y

## LASSO model
lasso_anyfall1y <- cv.glmnet(x=x_train, y=y_train, alpha=1, family="binomial", nfolds = 10)
plot(lasso_anyfall1y)
lasso_anyfall1y.min <- glmnet(x=x_train, y=y_train, alpha=1, family="binomial", lambda=lasso_anyfall1y$lambda.min)
coef(lasso_anyfall1y.min)

test$anyfall1y_pred_p <- predict(lasso_anyfall1y.min, x_test, type="response") %>% as.numeric()
test$anyfall1y_pred <- (test$anyfall1y_pred_p > 0.5)*1
class_anyfall1y <- test %>% group_by(anyfall1y, anyfall1y_pred) %>% tally()

## Calculate Sens, Spec, PPV, NPV
valid_anyfall1y <- valid_measures(class_anyfall1y)
valid_anyfall1y %>% write_csv("derived_data/valid_anyfall1y.csv")
print(valid_anyfall1y)

## ROC using testing set
roc_anyfall1y <- roc(test$anyfall1y, test$anyfall1y_pred_p)
auc(roc_anyfall1y)

## Plot ROC curve
png("figures/figure4_roc_anyfall1y.png", width = 400, height = 400)
plot(roc_anyfall1y, main = "Figure 4. ROC Curve for any fall risk", col = "blue")
dev.off()
