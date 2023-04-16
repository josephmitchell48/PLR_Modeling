function [latency, half_contraction, contractVel, contractAcc, qDilationDelay, hDilationDelay, dilationVel, dilationAcc] = get_stats(t, r, timeDelay)

radius = r(:,1);
velocity = r(:,2);
%figure();
%plot(t, radius);
%hold on;
%Latency 
inflextion_index = get_index(t, velocity);
inflextion_index = inflextion_index(1);
[~, start_index] = min(abs(t - timeDelay));

%plot(t(inflextion_index), r(inflextion_index), 'o', 'MarkerSize', 3, 'Color', 'black');
latency = t(inflextion_index) - t(start_index);
disp("Latency");
disp(latency + " s");

%%half contraction 
[~, min_radius_index] = min(radius);
%%%plot minimum point
%plot(t(min_radius_index(1)), r(min_radius_index(1)), 'o', 'MarkerSize', 3, 'Color', 'black');
%get midpoint index using radius values to calculate half contraction delay
[~, half_contract_index] = min(abs(r(1:min_radius_index(1)) - (r(min_radius_index(1)) + r(inflextion_index))/2));
%%%plot half point
%plot(t(half_contract_index), r(half_contract_index), 'o', 'MarkerSize', 3, 'Color', 'black');
%half contraction delay
half_contraction = t(half_contract_index) - t(start_index);
disp("Half Contraction Delay");
disp(half_contraction + " s");

%%contraction velocity (average)
contractVel = (r(min_radius_index(1)) - r(inflextion_index))/(t(min_radius_index(1)) - t(inflextion_index));
disp("Contraction Velocity");
disp(contractVel + " mm/s");
%plot([t(min_radius_index(1)), t(inflextion_index)], [r(min_radius_index(1)), r(inflextion_index)], 'r-');

max_acceleration_index = 0;
max_contract_accel = 0;
%%contraction acceleration (should be max)
for i = inflextion_index:min_radius_index - 1
    contract_acceleration = (velocity(i+1) - velocity(i))/(t(i+1) / t(i)); 
    if contract_acceleration > max_contract_accel
        max_contract_accel = contract_acceleration;
        max_acceleration_index = i+1;
    end
end
contractAcc = t(max_acceleration_index);
disp("Max Contraction Acceleration Time");
disp(contractAcc + " s");

%%quarter dilation
quarter_dilation = (r(inflextion_index) - r(min_radius_index(1)))/4 + r(min_radius_index(1));
%get midpoint index using radius values to calculate half contraction delay
[~, quar_dilation_index] = min(abs(r(min_radius_index(1):length(radius)) - quarter_dilation));
%%%plot half point
%plot(t(quar_dilation_index + min_radius_index(1)), r(quar_dilation_index + min_radius_index(1)), 'o', 'MarkerSize', 3, 'Color', 'black');
disp("Quarter Dilation Velocity");
%qDilationDelay = t(quar_dilation_index + min_radius_index(1)) - t(start_index);
qDilationDelay = (r(quar_dilation_index + min_radius_index(1)) - r(min_radius_index(1)))/(t(quar_dilation_index + min_radius_index(1)) - t(min_radius_index(1)));
disp(qDilationDelay + " mm/s");

%%half dilation
half_dilation = (r(start_index) - r(min_radius_index(1)))/2 + r(min_radius_index(1));
%get midpoint index using radius values to calculate half contraction delay
[~, half_dilation_index] = min(abs(r(min_radius_index(1):length(radius)) - half_dilation));
%%%plot half point
%plot(t(half_dilation_index + min_radius_index(1)), r(half_dilation_index + min_radius_index(1)), 'o', 'MarkerSize', 3, 'Color', 'black');
disp("Half Dilation");
hDilationDelay = t(half_dilation_index + min_radius_index(1)) - t(start_index);
disp(hDilationDelay + " s");

%%dilation velocity
dilationVel = (r(length(radius)) - r(min_radius_index(1)))/(t(length(t)) - t(min_radius_index(1)));
disp("Dilation Velocity");
disp(dilationVel + " mm/s");
%plot([t(length(t)), t(min_radius_index(1))], [r(length(radius)), r(min_radius_index(1))], 'b-');

%%dilation acceleration
max_velocity = abs(max(velocity(min_radius_index(1):length(velocity))));
dilationAcc = max_velocity/(t(length(t)) - t(min_radius_index(1)));

disp("Dilation Acceleration");
disp(dilationAcc + " mm/s^2");
