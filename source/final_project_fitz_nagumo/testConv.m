% Integration of models
v0 = [ -1.5; -3/8]; %initial conditions for V variable
tf = 5000; 
tspan = [0 tf];

%%% DEFINE MODEL PARAMETERS %%%
nerve2 = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2
nerve = FitzNagumo(0.008, 0.139, 0.04, 2.54); % Region 1

%%% NO DELAY %%%
[time,v1] = ode45(@(t, v) nerve2.dynamics(t, v), tspan, v0);

d1 = actionPotentials2deltas(v1(:,1));
twitches = impulse_response(time, 3, 15);

figure;
plot(time, v1(:,1));
hold on
plot(time, d1);


%%% WITH DELAY %%%

tau=5

f1_delay = @(t, v, tau) nerve2.delay_dynamics(t, v, tau);
v1_delay = dde23(f1_delay, tau, v0, tspan);
y1 = deval(v1_delay, time);

d1_delay = actionPotentials2deltas(y1(1,:));
twitches_delay = impulse_response(time, 3, 15);

plot(time, y1(1,:));
hold on
plot(time, d1_delay);
title('Action Potential and Impulse Responses');
legend('Normal','Delay');

% Plot The Convolution
F1 = conv(d1, twitches);
F1_delay = conv(d1_delay, twitches_delay);

figure();
plot(1:length(F1), F1);
hold on;
plot(1:length(F1_delay), F1_delay);
title('Muscle Response');
legend('Normal','Delay');


pm_delay = 220; % [ms]



