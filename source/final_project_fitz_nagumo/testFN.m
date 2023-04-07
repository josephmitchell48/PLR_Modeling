function fitz_nagumo_sys = testFN(t,V,LagV, model)
%IMPORTANT: V(1) = voltage function v(x,t)
%           V(2) = recovery function r(x,t)

%%% DEFINE MODEL PARAMETERS %%%
model = FitzNagumo(0.008, 0.139, 0.04, 2.54); % Region 1
nerve2 = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2
nerve3 = FitzNagumo(0.008, 0.139, 0.022, 4.65); % Region 3

Vlagged = LagV(:);

fitz_nagumo_sys = [V(1)*(model.alpha - V(1))*(V(1) - 1) - Vlagged(2) + model.initial_stimulus
                   model.epsilon*(V(1) - model.gamma*V(2))];

end

