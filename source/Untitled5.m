clc; close all

n = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2

% Table 1 fitted parameters 3: 
l0d = 3.57;
l0c = 0.93;
Kd = 1.24;
Kc = 0.047;
D = 3.78;
fp = 32.25;
fs = 9.43;
P0 = -1.007;
tao_p = 0.22;
tao_s = 0.77;

p = Pupil(Kc, Kd, l0c, l0d, D, fp, fs, P0,tao_p, tao_s);

t_orig = [0:0.01:1.5];
Fp_orig = p.Fp_orig(1:0.01:2.5);

time_conversion = 50000; %50 000 units of time = 1s in the nagumo model

v0 = [ 0.726; 4.4273]; 
time = 0:1:0.1*time_conversion;
time = time./time_conversion;

tau=0.0001;

f1 = @(t, v, tau) n.delay_dynamics(t, v, tau);
v1 = dde23(f1, tau, v0, [0 1*time_conversion]);
y1 = deval(v1, time*time_conversion);


d1 = actionPotentials2deltas(y1(1,:));
twitch = impulse_response(time*1000, 3, 15); %this takes ms values (0-1 second)

%%% WITH DELAY %%%
tau=9;

f1_delay = @(t, v, tau) n.delay_dynamics(t, v, tau);
v1_delay = dde23(f1_delay, tau, v0, [0 1*time_conversion]);
y1 = deval(v1_delay, time*time_conversion);

d1_delay = actionPotentials2deltas(y1(1,:));


muscle_force = conv(d1, twitch);
muscle_force_delay = conv(d1_delay, twitch);
twitch_time = [1:length(muscle_force)]/time_conversion;

norm_factor = max(muscle_force);
muscle_force = p.f_p.*muscle_force./norm_factor;
muscle_force_delay = p.f_p.*muscle_force_delay./norm_factor;


figure
plot(t_orig, Fp_orig);
hold on
plot(twitch_time+0.21, muscle_force) 
plot(twitch_time+0.21, muscle_force_delay);




