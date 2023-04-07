
p_version = 3;
tspan = [0 5];

[t_orig, r_orig] = simulate_orig(p_version, tspan);
% [t0, r0] = simulate(p_version, tspan, 0.00001);
% [t9, r9] = simulate(p_version, tspan, 9);
% [t20, r20] = simulate(p_version, tspan, 20);
% [t50, r50] = simulate(p_version, tspan, 50);
%[latency, half_contraction, contractVel, qDilationDelay, hDilationDelay, dilationVel, dilationAcc]...
%    = delay_function(t_orig, r_orig, 1);

taus = 0:2;
taus(1) = 0.00001;
% data(1,i) = latency
% data(2,i) = half_contraction
% data(3,i) = contractVel
% data(4,i) = qDilationDelay
% data(5,i) = hDilationDelay
% data(6,i) = dilationVel
% data(7,i) = dilationAcc
derived_data = zeros(7, length(taus));


for i=1:1
    [t, r] = simulate(p_version, tspan, taus(i));
    [latency, half_contraction, contractVel, qDilationDelay, hDilationDelay, dilationVel, dilationAcc]...
    = get_stats(t, r, 1);
    derived_data(1,i) = latency;
    derived_data(2,i) = half_contraction;
    derived_data(3,i) = contractVel;
    derived_data(4,i) = qDilationDelay;
    derived_data(5,i) = hDilationDelay;
    derived_data(6,i) = dilationVel;
    derived_data(7,i) = dilationAcc;
    
    figure 
    plot(t, r(:,1));
end


% figure
% plot(t_orig, r_orig);
% hold on;
% % plot(t0, r0);
% plot(t9, r9);
% % plot(t20, r20);
% % plot(t50, r50);
% 
% legend('Fan & Yao', 'FN tau=0', 'FN tau=9', 'FN tau=20', 'FN tau=50');
% title('PLR');
% xlabel('Time (s)');
% ylabel('Radius (mm)');