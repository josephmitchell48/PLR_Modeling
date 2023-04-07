classdef FitzNagumo
    properties
        epsilon  {mustBeNumeric}
        alpha  {mustBeNumeric}
        gamma  {mustBeNumeric}
        initial_stimulus  {mustBeNumeric}
    end
    
    methods
        
        function obj = FitzNagumo(epsilon, alpha, gamma, initial_stimulus)
            if nargin == 4
                obj.epsilon = epsilon;
                obj.alpha = alpha;
                obj.gamma = gamma;
                obj.initial_stimulus = initial_stimulus;
            end
        end
        
        function fitz_nagumo_sys = dynamics(obj, t, V)
            fitz_nagumo_sys = zeros(2,1);
            %IMPORTANT: V(1) = voltage function v(x,t); V(2) = recovery function r(x,t)
            fitz_nagumo_sys = [V(1)*(obj.alpha - V(1))*(V(1) - 1) - V(2) + obj.initial_stimulus;
                          obj.epsilon*(V(1) - obj.gamma*V(2))];
        end
        
        function fitz_nagumo_sys = delay_dynamics(obj, t, V, LagV)
            fitz_nagumo_sys = zeros(2,1);
            %IMPORTANT: V(1) = voltage function v(x,t); V(2) = recovery function r(x,t)
            fitz_nagumo_sys = [V(1)*(obj.alpha - V(1))*(V(1) - 1) - LagV(2) + obj.initial_stimulus;
                   obj.epsilon*(V(1) - obj.gamma*V(2))];
        end
    end
end