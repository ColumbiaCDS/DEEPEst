[<img src="images/CDSLogo.png" width=100 alt="CDS Logo"/>](https://www8.gsb.columbia.edu/decisionsciences/)

# DEEPEst

This R package provides functions to execute hierarchical Bayesian estimation for DEEP using [Stan](https://mc-stan.org) (via the **rstan** package). There are also some functions for posterior analysis on estimates of both time and risk preferences parameters.

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

### Reference

Toubia, O., Johnson, E., Evgeniou, T., & Delquié, P. (2013). Dynamic experiments for estimating preferences: An adaptive method of eliciting time and risk parameters. Management Science, 59(3), 613-640.