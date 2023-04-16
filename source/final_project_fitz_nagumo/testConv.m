% Integration of models
v0 = [ 0.726; 4.4273]; %initial conditions for V variable
tf = 0.5; 
time_conversion=50000;
tspan = [0 tf*time_conversion];

time = 0:1/time_conversion:tf;

%%% DEFINE MODEL PARAMETERS %%%
nerve2 = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2
nerve = FitzNagumo(0.008, 0.139, 0.04, 2.54); % Region 1

%%% NO DELAY %%%
tau=0.0001;

f1 = @(t, v, tau) nerve2.delay_dynamics(t, v, tau);
v1 = dde23(f1, tau, v0, [0 tf*time_conversion]);
y1 = deval(v1, time*time_conversion);

d1 = actionPotentials2deltas(y1(1,:));
twitches = impulse_response(time*1000, 3, 15);

figure;
plot(time,y1(1,:));
hold on
plot(time, d1);


%%% WITH DELAY %%%

tau=9;

f1_delay = @(t, v, tau) nerve2.delay_dynamics(t, v, tau);
v1_delay = dde23(f1_delay, tau, v0, [0 2]*time_conversion);
y1 = deval(v1_delay, time*time_conversion);

d1_delay = actionPotentials2deltas(y1(1,:));
twitches_delay = impulse_response(time*1000, 3, 15);

% Plot The Convolution
F1 = conv(d1, twitches);
F1_delay = conv(d1_delay, twitches);

f = figure();
plot([1:length(F1)].*1000./time_conversion, F1./max(F1));
hold on;
plot([1:length(F1_delay)].*1000./time_conversion, F1_delay./max(F1));


%% Tau = 20 %%
tau=20;

f1_delay = @(t, v, tau) nerve2.delay_dynamics(t, v, tau);
v1_delay = dde23(f1_delay, tau, v0, [0 2]*time_conversion);
y1 = deval(v1_delay, time*time_conversion);

d1_delay = actionPotentials2deltas(y1(1,:));
twitches_delay = impulse_response(time*1000, 3, 15);

% Plot The Convolution
F1 = conv(d1, twitches);
F1_delay = conv(d1_delay, twitches);

plot([1:length(F1_delay)].*1000./time_conversion, F1_delay./max(F1));


%% Tau = 50 %%
tau=50;

f1_delay = @(t, v, tau) nerve2.delay_dynamics(t, v, tau);
v1_delay = dde23(f1_delay, tau, v0, [0 2]*time_conversion);
y1 = deval(v1_delay, time*time_conversion);

d1_delay = actionPotentials2deltas(y1(1,:));
twitches_delay = impulse_response(time*1000, 3, 15);

% Plot The Convolution
F1 = conv(d1, twitches);
F1_delay = conv(d1_delay, twitches);

plot([1:length(F1_delay)].*1000./time_conversion, F1_delay./max(F1));


title('Muscle Response');
legend('Normal','Delay tau=9', 'Delay tau=20', 'Delay tau=50');




