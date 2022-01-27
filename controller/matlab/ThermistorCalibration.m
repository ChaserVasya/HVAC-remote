clear;

RTmap = getRTmap();

R = RTmap(:,1);
TCel  = RTmap(:,2);
TKel = convtemp(TCel, 'C','K');

%% LSM
% SteinhartHartEql: a + b*ln(R) + c*ln(R).^3 == 1/T ;

A = [ ones(height(R),1) log(R) log(R).^3 ];
b = 1./TKel;
c = A\b;

%%

save('coefs.mat','c');