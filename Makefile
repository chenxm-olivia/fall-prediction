.PHONY: clean

clean:
	rm -rf derived_data/*
	rm -rf figures/*
	rm -rf report.html
	mkdir -p derived_data
	mkdir -p figures

# Prepare analytic dataset 
derived_data/ds_clean.csv: \
 ds_cleaning.R\
 utils.R\
 source_data/NHATS_Round_1_SP_File.sas7bdat\
 source_data/NHATS_Round_2_SP_File_v2.sas7bdat
	Rscript ds_cleaning.R

# Generate figures to inspect data distribution
figures/figure1_fallstat_fallstat1y.png figures/figure2_sppb_fallstat1y.png figures/figure3_age_fallstat1y.png: \
 plots_predictors.R\
 derived_data/ds_clean.csv
	Rscript plots_predictors.R

# Apply LASSO logistic regression to predict 1-year fall risk
figures/figure4_roc_anyfall1y.png derived_data/valid_anyfall1y.csv: \
 lasso_anyfall1y.R\
 utils.R\
 derived_data/ds_clean.csv
	Rscript lasso_anyfall1y.R

# Apply LASSO logistic regression to predict 1-year multiple falls risk
figures/figure5_roc_multifall1y.png derived_data/valid_multifall1y.csv: \
 lasso_multifall1y.R\
 utils.R\
 derived_data/ds_clean.csv
	Rscript lasso_multifall1y.R

# Build final report
report.html: report.Rmd\
 figures/figure1_fallstat_fallstat1y.png\
 figures/figure2_sppb_fallstat1y.png\
 figures/figure3_age_fallstat1y.png\
 figures/figure4_roc_anyfall1y.png\
 figures/figure5_roc_multifall1y.png
	R -e "rmarkdown::render(\"report.Rmd\", output_format=\"html_document\")"