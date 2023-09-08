% Script to run pupil simulations and plot results

pupil_version = 3;
tspan = [0 3.5];

[t_orig, r_orig] = simulate_orig(pupil_version, tspan);
[t0, r0] = simulate(pupil_version, tspan, 0.00001);
[t9, r9] = simulate(pupil_version, tspan, 9);
[t20, r20] = simulate(pupil_version, tspan, 20);
[t50, r50] = simulate(pupil_version, tspan, 50);

figure
plot(t_orig, r_orig);
hold on;
plot(t0, r0);
plot(t9, r9);
plot(t20, r20);
plot(t50, r50);

legend('Fan & Yao', 'FN tau=0', 'FN tau=9', 'FN tau=20', 'FN tau=50');
title('PLR');
xlabel('Time (s)');
ylabel('Radius (mm)');