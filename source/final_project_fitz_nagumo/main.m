clc;  clear; close all;
v0 = [ -1.5; -3/8]; %initial conditions for V variable
tf = 5000; 
tspan = [0 tf];
time = linspace(0, tf, 5000);

%%% DEFINE MODEL PARAMETERS %%%
nerve1 = FitzNagumo(0.008, 0.139, 0.04, 2.54); % Region 1
nerve2 = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2
nerve3 = FitzNagumo(0.008, 0.139, 0.022, 4.65); % Region 3

%%% NO DELAY %%%
f1 = @(t, v) F_N(t, v, nerve1);
f2 = @(t, v) F_N(t, v, nerve2);
f3 = @(t, v) F_N(t, v, nerve3);
[t1,v1] = ode45(f1, tspan, v0); % v(1): the nuerons voltage value v(2): the neurons recovery variable value t: time series over which the data is simulated
[t2,v2] = ode45(f2, tspan, v0); % v(1): the nuerons voltage value v(2): the neurons recovery variable value t: time series over which the data is simulated
[t3,v3] = ode45(f3, tspan, v0); % v(1): the nuerons voltage value v(2): the neurons recovery variable value t: time series over which the data is simulated

%%% WITH DELAY %%%
tao = 1/(nerve1.gamma * nerve1.epsilon);
lags = 5;

f1_delay = @(t, v, lags) F_N_const_delay(t, v, lags, nerve1);
f2_delay = @(t, v, lags) F_N_const_delay(t, v, lags, nerve2);
f3_delay = @(t, v, lags) F_N_const_delay(t, v, lags, nerve3);

v1_delay = dde23(f1_delay, lags, v0, tspan);
v2_delay = dde23(f2_delay, lags, v0, tspan); 
v3_delay = dde23(f3_delay, lags, v0, tspan); 

y1 = deval(v1_delay, time);
y2 = deval(v2_delay, time);
y3 = deval(v3_delay, time);

%%% Region 1 %%%
figure(1);
subplot(2, 1, 1);
plot(t1,v1(:,1));
hold on;
plot(time,y1(1,:));
title('Voltage Output (V dot)');
legend('Normal','Delay')

subplot(2, 1, 2);
plot(t1,v1(:,2));
hold on;
plot(time,y1(2,:));
title('Recovery Output (R dot)');
legend('Normal','Delay')

%%% Region 2 %%%
figure(2);
subplot(2, 1, 1);
plot(t2,v2(:,1));
hold on;
plot(time,y2(1,:));
title('Voltage Output (V dot)');
legend('Normal','Delay')

subplot(2, 1, 2);
plot(t2,v2(:,2));
hold on;
plot(time,y2(2,:));
title('Recovery Output (R dot)');
legend('Normal','Delay')

%%% Region 3 %%%
figure(3);
subplot(2, 1, 1);
plot(t3,v3(:,1));
hold on;
plot(time,y3(1,:));
title('Voltage Output (V dot)');
legend('Normal','Delay')

subplot(2, 1, 2);
plot(t3,v3(:,2));
hold on;
plot(time,y3(2,:));
title('Recovery Output (R dot)');
legend('Normal','Delay')
