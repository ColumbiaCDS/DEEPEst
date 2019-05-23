[<img src="images/CDSLogo.png" width=100 alt="CDS Logo"/>](https://www8.gsb.columbia.edu/decisionsciences/)

# DEEPEst

This R package provides functions to execute hierarchical Bayesian estimation for DEEP using [Stan](https://mc-stan.org) (via the **rstan** package). These high level functions will automatically call [Stan](https://mc-stan.org) functions so that you don't need to dive into them by yourself. There are also some functions for posterior analysis on estimates of both time and risk preferences parameters.

### Dynamic Experiments for Estimating Preferences (DEEP)

In trying to understand choices, people would like to know the decision maker's underlying preferences. DEEP (Toubia et al, 2013) is a novel methodology to elicit individuals' risk (DEEP Risk) or time (DEEP Time) preferences by dynamically (i.e., adaptively) optimizing the sequences of questions presented to each subject, while leveraging information about the distribution of the parameters across individuals (heterogeneity) and modeling response error explicitly.

To customize and launch your own DEEP survey, refer to our [survey page](http://). When survey is completed by enough subjects, install the **DEEPEst** package and start estimation.

### Installation

To install from GitHub, please first install the **rstan** package and C++ toolchain with these [instructions](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started).
Then, you can install **DEEPEst** from GitHub using the **devtools** package by executing the following in R:

```r
devtools::install_github("ColumbiaCDS/DEEPEst")
```

If installation fails, please email cds@decisionsciences.columbia.edu.

### Run Estimation

Download the original survey data csv file into your working directory. And for illustration, let's say the working directory here is "./DEEP Your_Name". 

Then, rename this original csv file to be "DEEP_{model}_surveydata_{project_name}.csv". Here, "{model}" should be either "Time" or "Risk" depending on your project and "{project_name}" should be a unique name indentifying this project. For example, you may name it as "DEEP_Time_surveydata_StudyNo1.csv".

Then execute the following:

```r
# For DEEP Time
library(DEEPEst)
Time_data_prepare(project_name = "StudyNo1", path = , num_question = 12)
Stan_Time_Estimation(project_name = "StudyNo1", num_question_Est = 12, 
					 num_question = 12, type_theta = "Hier", path = )
```

```r
# For DEEP Risk
library(DEEPEst)
Risk_data_prepare(project_name = "StudyNo1", path = , num_question = 16)
Stan_Risk_Estimation(project_name = "StudyNo1", num_question_Est = 16, 
					 num_question = 16, type_theta = "Hier", path = )
```



<details><summary>Run Estimation</summary>



### Reference

[Toubia, O., Johnson, E., Evgeniou, T., & Delquié, P. (2013). Dynamic experiments for estimating preferences: An adaptive method of eliciting time and risk parameters. Management Science, 59(3), 613-640.](https://pubsonline.informs.org/doi/abs/10.1287/mnsc.1120.1570)
