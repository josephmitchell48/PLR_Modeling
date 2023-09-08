% Integration of models
v0 = [ -1.5; -3/8]; %initial conditions for V variable
tf = 5000; 
tspan = [0 tf];
time = linspace(0, tf, 5000);

%%% DEFINE MODEL PARAMETERS %%%
nerve1 = FitzNagumo(0.008, 0.139, 0.04, 2.54); % Region 1
% nerve2 = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2
% nerve3 = FitzNagumo(0.008, 0.139, 0.022, 4.65); % Region 3

%%% NO DELAY %%%
f1 = @(t, v) F_N(t, v, nerve1);
% f2 = @(t, v) F_N(t, v, nerve2);
% f3 = @(t, v) F_N(t, v, nerve3);
[t1,v1] = ode45(f1, tspan, v0); % v(1): the nuerons voltage value v(2): the neurons recovery variable value t: time series over which the data is simulated
% [t2,v2] = ode45(f2, tspan, v0); % v(1): the nuerons voltage value v(2): the neurons recovery variable value t: time series over which the data is simulated
% [t3,v3] = ode45(f3, tspan, v0); % v(1): the nuerons voltage value v(2): the neurons recovery variable value t: time series over which the data is simulated


d1 = actionPotentials2deltas(v1(:,1));
twitches = impulse_response(t1, 100, 500, 1000);

plot(t1, v1(:,1));
hold on
plot(t1, d1);


% twitch = impulse_response(t1, 100,500,1000)
F1 = conv(d1, twitches);

figure();
plot(1:length(F1), F1);
