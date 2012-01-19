function dprime = eer2dprime(eer)
%function dprime = eer2dprime(eer)

dprime = 2*norminv((1 - eer),0,1);
