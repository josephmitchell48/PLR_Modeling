classdef Pupil
    %Pupil is a class that stores values Yan and Yao model of PLR
    
    properties
        K_c % 2pi k_c/m - normalized elastic constant for constrictor
        K_d % k_d/m - normalized elastic constant for dilator
        l_0c % resting length of constrictor muscle
        l_0d % resting length of dilator muscle
        D % (D_c + D_d)/m - normalized damping factor for whole pupil
        f_p % fp/2pi - normalized parasympathetic force
        f_s % sympathetic force
        P_0 % static force that controls resting pupil size
        tao_p % parasympathetic delay
        tao_s % sympathetic delay
        flash_duration = 0.1 % length of flash duration (set to 0.1s)
    end
    
    methods
        function obj = Pupil(Kc, Kd,l0c, l0d, D, fp, fs, P0, tao_p, tao_s)
            %Pupil
            %   Detailed explanation goes here
            obj.K_c = Kc;
            obj.K_d = Kd;
            obj.l_0c = l0c;
            obj.l_0d = l0d;
            obj.D = D;
            obj.f_p = fp;
            obj.f_s = fs;
            obj.P_0 = P0; 
            obj.tao_p = tao_p;
            obj.tao_s = tao_s;
            obj.flash_duration = 0.1; % default 100ms
            
        end
        
        function forces = Fp_orig(obj, T)
            %Fp_orig returns parasympathetic force as described in Fan 
            % & Yao's paper that starts at 1s and lasts as long as the 
            % set flash duration
            %   T = time points to evaluate on
            forces = zeros(size(T));
            forces(T>=1+obj.tao_p & T<= 1+obj.tao_p+obj.flash_duration) = obj.f_p;
        end
        
        function forces = Fs_orig(obj, T)
            % Fs_orig returns the sympathetic force as described in Fan & 
            % Yao's paper that starts at 1s and lasts as long as the 
            % set flash duration
            % T = time points to evaluate on 
            forces = zeros(size(T));
            forces(T>=1+obj.tao_s & T<= 1+obj.tao_s+obj.flash_duration) = obj.f_s;
        end
        
        function force = get_elastic_force(obj, r)
            % Inputs: 
            %   r = radius
            force = obj.K_d*(obj.l_0d - r).^2 - obj.K_c*(obj.l_0c - r).^2;
        end
        
        function force = get_damping_force(obj, r_dot)
            % Inputs:
            %   r_dot = d(radius)/dt
            force = obj.D*r_dot;
        end
        
        
    end
end
