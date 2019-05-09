functions {
  real cal_value(real x, real p, real y, real q, real alpha, real sigma, real lambda){
    real v;
    if (x < 0 && 0 < y)
      v = exp(-(-log(p))^alpha) * (-lambda) * (-x)^sigma + exp(-(-log(q))^alpha) * y^sigma;
    else if (y < 0 && x < 0)
      v = -lambda*(-y)^sigma + exp(-(-log(p))^alpha) * (-lambda*(-x)^sigma - (-lambda*(-y)^sigma));
    else 
      v = y^sigma + exp(-(-log(p))^alpha) * (x^sigma - y^sigma);
    return v;
  }
}
data {
  int<lower=1> nchoice;
  int<lower=1> npart;
  matrix[npart, nchoice] x1;
  matrix[npart, nchoice] p1;
  matrix[npart, nchoice] y1;
  matrix[npart, nchoice] q1;
  matrix[npart, nchoice] x2;
  matrix[npart, nchoice] p2;
  matrix[npart, nchoice] y2;
  matrix[npart, nchoice] q2;
  int<lower=0, upper=1> choices[npart, nchoice];
}
parameters {
  real mualpha;
  real<lower=0, upper=2> sigmaalpha;
  vector<lower=0.05, upper=2>[npart] alpha;
  real musigma;
  real<lower=0, upper=2> sigmasigma;
  vector<lower=0.05, upper=2>[npart] sigma;
  real mulambda;
  real<lower=0, upper=2> sigmalambda;
  vector<lower=0.05, upper=10>[npart] lambda;
  vector<lower=0>[npart] theta;
}
transformed parameters {
  matrix[npart, nchoice] v1; 
  matrix[npart, nchoice] v2; 
  for(p in 1:npart) {
    for(i in 1:nchoice){
      v1[p, i] = cal_value(x1[p, i], p1[p, i], y1[p, i], q1[p, i], alpha[p], sigma[p], lambda[p]);
      v2[p, i] = cal_value(x2[p, i], p2[p, i], y2[p, i], q2[p, i], alpha[p], sigma[p], lambda[p]);
    }
  }
}
model{
  mualpha ~ normal(0.6, 1);
  musigma ~ normal(0.8, 1);
  mulambda ~ normal(1.8, 1);
  theta ~ lognormal(0.5, 1);
  sigmaalpha ~ uniform(0, 2);
  sigmasigma ~ uniform(0, 2);
  sigmalambda ~ uniform(0, 2);
  for(p in 1:npart){
    alpha[p] ~ normal(mualpha, sigmaalpha) T[0.05, 2];
    sigma[p] ~ normal(musigma, sigmasigma) T[0.05, 2];    
    lambda[p] ~ lognormal(mulambda, sigmalambda) T[0.05, 10];
  }
  for(p in 1:npart) {
      choices[p] ~ bernoulli_logit(theta[p] * (v2[p] - v1[p]));
  }
}
generated quantities{
  matrix[npart, nchoice] postpred;
  real<lower = 0> gsq [npart];
  real ll[nchoice];
  real choiceper;
  for(p in 1:npart) {
    for(i in 1:nchoice){
      postpred[p,i] = bernoulli_logit_rng(theta[p] * (v2[p,i] - v1[p,i]));
      choiceper = inv_logit(theta[p] * (v2[p, i] - v1[p, i]));
      ll[i] = choices[p, i] == 1 ? log(choiceper) : log(1 - choiceper);
    }
    gsq[p] = -2 * sum(ll);
  }
}

