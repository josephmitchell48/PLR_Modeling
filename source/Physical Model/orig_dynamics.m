function [x_dot] = orig_dynamics(x, p, T)
%dynamics state space dynamics for physical pupil model as in Fan and Yao
%   Inputs: 
% x(1): r (radius)
% x(2): dr/dt (radius_dot)
% p: Pupil object
% T: time
%   Output:
% x_dot(1): dr/dt
% x_dot(2): d2r/dt2
    

F_elastic = p.get_elastic_force(x(1));
F_damping = p.get_damping_force(x(2));
Fp = p.Fp_orig(T);
Fs = p.Fs_orig(T);

x_dot = [x(2);  
         F_elastic - F_damping - Fp + Fs + p.P_0];

end
