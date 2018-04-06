clear all; close all;
% foraging simulation
%% Define parameters
% Time Parameters
xmax = 1000; % Max x coordinate of the environment
ymax = 1000; % Max y coordinate of the environment
total_time = 10000; % Total length of simulation
dt = 1; % timestep
tvec = dt:dt:total_time; % time vector
nrewards = 9; % # of rewards
tfrac = total_time/(nrewards+1); % roughly the time in between rewards
% calculate onset times of each reward
for i=1:nrewards
    rtimes(i) = (i-1)*tfrac + 1;
end
% Location parameters
for i=1:sqrt(nrewards)
    xloc(i) = round(i*(xmax/(sqrt(nrewards)+1)));
    yloc(i) = round(i*(ymax/(sqrt(nrewards)+1)));
end
count = 0;
for i=1:length(yloc)
    for j=1:length(xloc)
        count = count+1;
        rlocs(count,:) = [xloc(j) yloc(i)];
    end
end
% Value / size parameters
rvals = ones(1,nrewards)*10000;
rrad = (xmax/sqrt(nrewards))^2;
x0 = xmax/2; y0 = ymax/2;
Rdx = 1;
Rdy = 1;
% Navigation parameters
sigma = 3;
lambda = 10000;
% Stay/Switch firing rate network parameters
we0 = 50;
wei = 50;
wie = 50;
W = [we0 0 wie 0; 0 we0 0 wie; 0 wei 0 0; wei 0 0 0];
taur = .1; % firing rate time constant
taud = .5; % depression time constant
tau_s_e = .05;
tau_s_i = .005;
r_e_max = 100;
r_i_max = 200;
%% Generate Reward fields
%[R] = genRewardField(locs,times,vals,total_time,dt,maxx,maxy);

%% Simulate foraging
[pos,R,dxs,dys,r_acc,RdecayVals] = forage(x0,y0,xmax,ymax,rtimes,rlocs,rvals,rrad,tvec,dt,Rdx,Rdy,sigma,lambda);

%% make movie
[mov] = makeForagingMovie(R,rtimes,r_acc,RdecayVals,total_time,pos,dxs,dys,50);

