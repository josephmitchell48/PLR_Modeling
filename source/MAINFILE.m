
p_version = 3;
tspan = [0 5];

[t_orig, r_orig] = simulate_orig(p_version, tspan);
% [t0, r0] = simulate(p_version, tspan, 0.00001);
% [t9, r9] = simulate(p_version, tspan, 9);
% [t20, r20] = simulate(p_version, tspan, 20);
% [t50, r50] = simulate(p_version, tspan, 50);
[latency, half_contraction, contractVel, qDilationDelay, hDilationDelay, dilationVel, dilationAcc]...
    = get_stats(t_orig, r_orig, 1);

taus = 0:50;
taus(1) = 0.00001;
% data(1,i) = latency
% data(2,i) = half_contraction
% data(3,i) = contractVel
% data(4,i) = qDilationDelay
% data(5,i) = hDilationDelay
% data(6,i) = dilationVel
% data(7,i) = dilationAcc
derived_data = zeros(8, length(taus));

for i=1:length(taus)
    [t, r] = simulate(p_version, tspan, taus(i));
    [latency, half_contraction, contractVel, contractAcc, qDilationDelay, hDilationDelay, dilationVel, dilationAcc]...
    = get_stats(t, r, 1);
    derived_data(1,i) = latency;
    derived_data(2,i) = half_contraction;
    derived_data(3,i) = contractVel;
    derived_data(4,i) = contractAcc;
    derived_data(5,i) = qDilationDelay;
    derived_data(6,i) = hDilationDelay;
    derived_data(7,i) = dilationVel;
    derived_data(8,i) = dilationAcc;
end

writematrix(derived_data, "output.csv");
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