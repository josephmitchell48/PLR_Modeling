function [t_orig, r_orig] = simulate_orig(pupil_version, tspan)
%function to simulate using FN model 
%   pupil_version: integer corresponding to the fitted values from Yan
%        paper
%   tspan: [t0 t_final] in seconds
%   Outputs:
%       t - time points
%       r_orig(1) - radius values of original model (Yan)
%       r_orig(2) - velocity values of original model (Yan)


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

%% SIMULATE ORIGINAL VERSION %%
f = @(t, x) orig_dynamics(x, p, t);

options = odeset('RelTol', 1e-6);
y0 = [2.68 0]; % start at radius of 2.68mm

[t_orig, r_orig] = ode45(f, tspan, y0, options);

end