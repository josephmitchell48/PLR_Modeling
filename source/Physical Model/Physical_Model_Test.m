% clc;  clear; close all;
% Table 1 fitted parameters 1: 
l0d = 3.59;
l0c = 0.91;
Kd = 1.24;
Kc = 0.059;
D = 3.78;
fp = 12.73;
fs = 9.10;
P0 = -0.760;
tao_p = 0.26;
tao_s = 0.64;

p1 = Pupil(Kc, Kd, l0c, l0d, D, fp, fs, P0, tao_p, tao_s);

% Table 1 fitted parameters 2: 
% l0d = 3.59;
% l0c = 0.92;
% Kd = 1.29;
% Kc = 0.065;
% D = 3.78;
% fp = 27.38;
% fs = 10.65;
% P0 = -0.736;
% tao_p = 0.24;
% tao_s = 0.73;
l0d = 3.59;
l0c = 0.92;
Kd = 1.29;
Kc = 0.065;
D = 3.78;
fp = 27.38;
fs = 10.65;
P0 = -0.736;
tao_p = 0.24;
tao_s = 0.73;

p2 = Pupil(Kc, Kd, l0c, l0d, D, fp, fs, P0,tao_p, tao_s);

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

p3 = Pupil(Kc, Kd, l0c, l0d, D, fp, fs, P0,tao_p, tao_s);

f1 = @(t, x) orig_dynamics(x, p1, t);
f2 = @(t, x) orig_dynamics(x, p2, t);
f3 = @(t, x) orig_dynamics(x, p3, t);

% Simulation parameters:
tspan = [0 3.5];
options = odeset('RelTol', 1e-6);
y0 = [2.68 0]; % start at radius of 2.68mm

[t1, r1] = ode45(f1, tspan, y0, options);
[t2, r2] = ode45(f2, tspan, y0, options);
[t3, r3] = ode45(f3, tspan, y0, options);

radius1 = r1(:,1);
radius2 = r2(:,1);
radius3 = r3(:,1);

f1 =figure();
hold on

plot(t1, radius1);
plot(t2, radius2); 
plot(t3, radius3);

ylim([1.8 2.8]);

T = [0:0.01:3.5];
Fp1 = p1.Fp_orig(T);
Fp2 = p2.Fp_orig(T);
Fp3 = p3.Fp_orig(T);
Fs1 = p1.Fs_orig(T);
Fs2 = p2.Fs_orig(T);
Fs3 = p3.Fs_orig(T);

pulse = zeros(size(T));
pulse(T>1 & T<1.1) = 1;

f2 = figure();
subplot(2,1,1);
hold on;
plot(T, Fp1);
plot(T, Fp2); 
plot(T, Fp3);
plot(T, pulse);
title('Fp');

subplot(2,1,2);
hold on;
plot(T, Fs1);
plot(T, Fs2);
plot(T, Fs3);
plot(T, pulse);
title('Fs');