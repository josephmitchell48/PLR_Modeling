function [latency, half_contraction, contractVel, qDilationDelay, hDilationDelay, dilationVel, dilationAcc] = get_stats(t, r, timeDelay)

radius = r(:,1);
velocity = r(:,2);
figure();
plot(t, radius);
hold on;
%Latency 
inflextion_index = get_index(t, velocity);
[~, start_index] = min(abs(t - timeDelay));

plot(t(start_index), r(start_index), 'o', 'MarkerSize', 3, 'Color', 'black');
latency = t(inflextion_index) - t(start_index);
disp("Latency");
disp(latency + " s");

%%half contraction 
[~, min_radius_index] = min(radius);
%%plot minimum point
plot(t(min_radius_index(1)), r(min_radius_index(1)), 'o', 'MarkerSize', 3, 'Color', 'black');
%get midpoint index using radius values to calculate half contraction delay
[~, half_contract_index] = min(abs(r(1:min_radius_index(1)) - (r(min_radius_index(1)) + r(inflextion_index))/2));
%%plot half point
plot(t(half_contract_index), r(half_contract_index), 'o', 'MarkerSize', 3, 'Color', 'black');
%half contraction delay
half_contraction = t(half_contract_index) - t(start_index);
disp("Half Contraction Delay");
disp(half_contraction + " s");

%%contraction velocity (average)
contractVel = (r(min_radius_index(1)) - r(inflextion_index))/(t(min_radius_index(1)) - t(inflextion_index));
disp("Contraction Velocity");
disp(contractVel + " mm/s");
plot([t(min_radius_index(1)), t(start_index)], [r(min_radius_index(1)), r(start_index)], 'r-');

%%contraction acceleration (should be max)
max_velocity = abs(min(velocity(inflextion_index:min_radius_index(1))));
contractAcc = max_velocity/(t(min_radius_index(1)) - t(inflextion_index));
disp("Contraction Acceleration");
disp(contractAcc + " mm/s^2");

%%quarter dilation
quarter_dilation = (r(inflextion_index) - r(min_radius_index(1)))/4 + r(min_radius_index(1));
%get midpoint index using radius values to calculate half contraction delay
[~, quar_dilation_index] = min(abs(r(min_radius_index(1):length(radius)) - quarter_dilation));
%%plot half point
plot(t(quar_dilation_index + min_radius_index(1)), r(quar_dilation_index + min_radius_index(1)), 'o', 'MarkerSize', 3, 'Color', 'black');
disp("Quarter Dilation");
qDilationDelay = t(quar_dilation_index + min_radius_index(1)) - t(start_index);
disp(qDilationDelay + " s");

%%half dilation
half_dilation = (r(start_index) - r(min_radius_index(1)))/2 + r(min_radius_index(1));
%get midpoint index using radius values to calculate half contraction delay
[~, half_dilation_index] = min(abs(r(min_radius_index(1):length(radius)) - half_dilation));
%%plot half point
plot(t(half_dilation_index + min_radius_index(1)), r(half_dilation_index + min_radius_index(1)), 'o', 'MarkerSize', 3, 'Color', 'black');
disp("Half Dilation");
hDilationDelay = t(half_dilation_index + min_radius_index(1)) - t(start_index);
disp(hDilationDelay + " s");

%%dilation velocity
dilationVel = (r(length(radius)) - r(min_radius_index(1)))/(t(length(t)) - t(min_radius_index(1)));
disp("Dilation Velocity");
disp(dilationVel + " mm/s");
plot([t(length(t)), t(min_radius_index(1))], [r(length(radius)), r(min_radius_index(1))], 'b-');

%%dilation acceleration
dilationAcc = dilationVel/(t(length(t)) - t(min_radius_index(1)));
disp("Dilation Acceleration");
disp(dilationAcc + " mm/s^2");
