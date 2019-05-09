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
  real<lower=0> sigmabeta;
  real<lower=0> sigmadelta_phi;
  vector<lower=0, upper=2>[npart] beta;
  vector[npart] delta_phi;
  real<lower=0> global_theta;
}
transformed parameters {
  vector<lower=0>[npart] r;
  vector<lower=0, upper=1>[npart] delta;
  matrix[npart, nchoice] vss; 
  matrix[npart, nchoice] vll;
  delta = Phi(delta_phi);
  r = -log(delta)/365;
  for(p in 1:npart){
    for(i in 1:nchoice){
      vss[p,i] = ss_delay[p, i] == 0 ? ss_amnt[p,i] : ss_amnt[p,i] * beta[p] * exp(-r[p] * ss_delay[p, i]);
      vll[p,i] = ll_amnt[p,i] * beta[p] *exp(-r[p] * ll_delay[p, i]);
    }
  }
}
model{
  mubeta ~ normal(0.8, 1);
  mudelta_phi ~ normal(0, 1);
  sigmabeta ~ uniform(0, 0.5);
  sigmadelta_phi ~ uniform(0, 10);
  global_theta ~ normal(.05, .5);
  for(p in 1:npart) {
    beta[p] ~ normal(mubeta, sigmabeta) T[0, 2];
    delta_phi[p] ~ normal(mudelta_phi, sigmadelta_phi);
    choices[p] ~ bernoulli_logit(global_theta * (vll[p] - vss[p]));
  }
}
generated quantities{
  matrix[npart, nchoice] postpred;
  real<lower = 0> gsq [npart];
  real ll[nchoice];
  real choiceper;
  for(p in 1:npart) {
    for(i in 1:nchoice){
      postpred[p,i] = bernoulli_logit_rng(global_theta * (vll[p,i] - vss[p,i]));
      choiceper = inv_logit(global_theta * (vll[p, i] - vss[p, i]));
      ll[i] = choices[p, i] == 1 ? log(choiceper) : log(1 - choiceper);
    }
    gsq[p] = -2 * sum(ll);
  }
}

