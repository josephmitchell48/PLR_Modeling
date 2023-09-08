function [x_dot] = dynamics(x, p, T, t_F, Fp_FN, Fs_FN)
% Updated state space dynamics for physical pupil model as in Fan and Yao
%   Inputs: 
% x(1): r (radius)
% x(2): dr/dt (radius_dot)
% p: Pupil object
% T: time
% t_Fp: time values for Fp function (needed for interp1)
% Fp: force values for Fp function
% alpha: 0 for no alcohol, 1 for alcohol
%   Output:
% x_dot(1): dr/dt
% x_dot(2): d2r/dt2

    F_elastic = p.get_elastic_force(x(1));
    F_damping = p.get_damping_force(x(2));
    
    Fp = interp1(t_F+1+p.tao_p - 0.01, Fp_FN,T, 'linear', 0);
    Fs = interp1(t_F+1+p.tao_s - 0.01, Fs_FN,T, 'linear', 0);
%     Fs = p.Fs_orig(T);
    
    x_dot = [x(2);  
             F_elastic - F_damping - Fp + Fs + p.P_0];
    
end

