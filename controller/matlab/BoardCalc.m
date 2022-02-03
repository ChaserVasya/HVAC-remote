clear;
close all;

%%

syms  R T 

load('coefs.mat');

SteinhartHart_TfromR = @(R)1./(c(1) + c(2).*log(R) + c(3).*log(R).^3);

%% 

syms Rlower Vout

Rupper = 46000;
Vin = 3.3;

Divider = Vin/(1 + Rupper/Rlower) == Vout;

%% main

RRange = [ 10^4  4*10^5 ];
RSet = linspace(RRange(1),RRange(2));
TSet = SteinhartHart_TfromR(RSet);

VoutSet = [];
parfor i = 1:length(RSet)
    VoutSet(i) = double(solve(subs(Divider,Rlower,RSet(i))));
end

%%

figure('Name',"V divider range");
semilogx(RSet,VoutSet);
hold all;

figure('Name',"T from R");
semilogx(RSet,convtemp(TSet,'K','C'));
hold all;
RTmap = getRTmap();
semilogx(RTmap(:,1),RTmap(:,2),'O');

