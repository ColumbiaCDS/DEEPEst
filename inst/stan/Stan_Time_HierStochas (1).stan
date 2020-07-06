data {
  int<lower=1> nchoice;
  int<lower=1> npart;
  matrix[npart, nchoice] ss_amnt;
  matrix[npart, nchoice] ss_delay;
  matrix[npart, nchoice] ll_amnt;
  matrix[npart, nchoice] ll_delay;
  int choices[npart, nchoice];
}
parameters {
  real mubeta;
  real mudelta_phi;
  real mutheta;
  real<lower=0> sigmabeta;
  real<lower=0> sigmadelta_phi;
  real<lower=0> sigmatheta;
  vector[npart] beta;
  vector[npart] delta_phi;
  //matrix[npart, nchoice] delta_phi_trial;
  matrix[npart, nchoice] delta_raw;
  matrix[npart, nchoice] beta_raw;
  
  vector<lower=0>[npart] theta;
  vector<lower=0>[npart] theta_beta;
}
transformed parameters {
  vector<lower=0>[nchoice] r[npart];
  vector<lower=0, upper=1>[nchoice] delta[npart];
  matrix<lower=0, upper=2>[npart, nchoice] beta_trial;
  matrix[npart, nchoice] vss; 
  matrix[npart, nchoice] vll;
  
  for(p in 1:npart){
    for(i in 1:nchoice){
      
      delta[p,i] = Phi(delta_phi[p] + theta[p] * delta_raw[p,i]);
      beta_trial[p,i] = Phi(beta[p] + theta_beta[p] * beta_raw[p,i])*2;
      r[p,i] = -log(delta[p,i])/365;
      vss[p,i] = ss_delay[p, i] == 0 ? ss_amnt[p,i] : ss_amnt[p,i] *beta_trial[p,i] * exp(-r[p,i] * ss_delay[p, i]);
      vll[p,i] = ll_amnt[p,i] * beta_trial[p,i] *exp(-r[p,i] * ll_delay[p, i]);
    }
  }
}
model{
  mubeta ~ normal(0, 1);
  mudelta_phi ~ normal(0, 1);
  mutheta ~ normal(0, 1);
  sigmabeta ~ uniform(0, 0.5);
  sigmadelta_phi ~ uniform(0, 10);
  sigmatheta ~ normal(0, 1);
 
  to_vector(theta) ~ normal(mutheta, sigmatheta);
  to_vector(theta_beta) ~ normal(mutheta, sigmatheta);
  to_vector(beta) ~ normal(mubeta, sigmabeta);
  to_vector(delta_phi) ~ normal(mudelta_phi, sigmadelta_phi);
  for(p in 1:npart) {
    choices[p] ~ bernoulli_logit((vll[p] - vss[p]));
    for (i in 1:nchoice){
        delta_raw[p,i] ~ normal(0,1);
        beta_raw[p,i] ~ normal(0,1);
    //  delta_phi_trial[p,i]  ~ normal(delta_phi[p], theta[p]);
    //  beta_trial[p,i]  ~ normal(beta[p], theta_beta[p]);
    }
  }
}
generated quantities{
  matrix[npart, nchoice] postpred;
  real<lower = 0> gsq [npart];
  real ll[nchoice];
  real choiceper;
  for(p in 1:npart) {
    for(i in 1:nchoice){
      postpred[p,i] = bernoulli_logit_rng(theta[p] * (vll[p,i] - vss[p,i]));
      choiceper = inv_logit(theta[p] * (vll[p, i] - vss[p, i]));
      ll[i] = choices[p, i] == 1 ? log(choiceper) : log(1 - choiceper);
    }
    gsq[p] = -2 * sum(ll);
  }
}

