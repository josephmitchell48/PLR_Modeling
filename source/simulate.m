function [t, r] = simulate(pupil_version, tspan, tau)
%function to simulate using FN model 
%   pupil_version: integer corresponding to the fitted values from Yan
%        paper
%   tspan: [t0 t_final] in seconds
%   tau: delay factor in FN model
%   Outputs:
%       t - time points
%       r - radius values 

if pupil_version==1
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
    p = Pupil(Kc, Kd, l0c, l0d, D, fp, fs, P0, tao_p, tao_s);
    
elseif pupil_version==2
    l0d = 3.59;
    l0c = 0.92;
    Kd = 1.29;
    Kc = 0.065;
    D = 3.78;
    fp = 28.38;
    fs = 10.65;
    P0 = -0.736;
    tao_p = 0.24;
    tao_s = 0.73;
    p = Pupil(Kc, Kd, l0c, l0d, D, fp, fs, P0,tao_p, tao_s);
    
elseif pupil_version==3
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
else % default to version 3 
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
end

%%  SIMULATE FITZ-NAGUMO NERVE WITHOUT DELAY %%

time_conversion = 50000; %50 000 units of time = 1s in the nagumo model
n = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2 limit cycle
v0 = [0.726; 4.4273]; %initial conditions of nerve

time = 0:1:0.1*time_conversion;
time = time./time_conversion;

tau0 = 0.0001; 
f1 = @(t, v, tau) n.delay_dynamics(t, v, tau);
v1 = dde23(f1, tau0, v0, [0 1*time_conversion]);
v_tau0 = deval(v1, time*time_conversion);

% CALCULATE MUSCLE RESPONSES %

d = actionPotentials2deltas(v_tau0(1,:));
twitch_time = [0:time_conversion]./time_conversion;
twitch = impulse_response(twitch_time*1000, 3, 15); % time*1000 because this takes ms
F_FN = conv(d, twitch);
F_FN_max = max(F_FN);


f_delay=@(t, v, tau) n.delay_dynamics(t, v, tau);
v1_delay = dde23(f_delay, tau, v0,[0 1*time_conversion]);
v_tau = deval(v1_delay, time*time_conversion);
  
d_tau = actionPotentials2deltas(v_tau(1,:));
F_FN_tau = conv(d_tau, twitch);
F_FN_tau = F_FN_tau./F_FN_max;
FpFN_tau = F_FN_tau*p.f_p;
FsFN_tau = F_FN_tau*p.f_s;
    
options = odeset('RelTol', 1e-6);
y0 = [2.68 0]; % start at radius of 2.68mm

f_tau = @(t,x) dynamics(x, p, t, [1:length(FpFN_tau)]./time_conversion, FpFN_tau, FsFN_tau);
[t, r_FN_tau] = ode45(f_tau, tspan, y0, options);
r = r_FN_tau(:,1);

end

