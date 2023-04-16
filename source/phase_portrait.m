clc; close all

% n = FitzNagumo(0.008, 0.139, 0.04, 4.4); % Region 1
% n = FitzNagumo(0.008, 0.139, 0.027, 4.42); % Region 2
n = FitzNagumo(0.008, 0.139, 0.022, 4.4); % Region 3

time_conversion = 50000; %50 000 units of time = 1s in the nagumo model

v0 = [ 0.726; 4.4273]; 
time = 0:1:.01*time_conversion;
time = time./time_conversion;

tau=0.0001;

f1 = @(t, v, tau) n.delay_dynamics(t, v, tau);
v1 = dde23(f1, tau, v0, [0 1*time_conversion]);
y1 = deval(v1, time*time_conversion);
dy1_dx = gradient(y1(1,:))./gradient(time*time_conversion);  % Calculate the derivative
dy2_dx = gradient(y1(2,:))./gradient(time*time_conversion);  % Calculate the derivative


figure
quiver(y1(1,:), y1(2,:),dy1_dx ,dy2_dx, 'r', 'AutoScale', 'off', 'MaxHeadSize', 0.05)
title('Region 3')

% f2 = @(t, v, tau) n.delay_dynamics(t, v, tau);
% v2 = dde23(f2, tau, v0, [0 1*time_conversion]);
% y2 = deval(v2, time*time_conversion);
% dy1_dx2 = gradient(y2(1,:))./gradient(time*time_conversion);  % Calculate the derivative
% dy2_dx2 = gradient(y2(2,:))./gradient(time*time_conversion);  % Calculate the derivative

% subplot(1,3,1);
% quiver(y1(1,:), y1(2,:),dy1_dx ,dy2_dx, 0 )
% title('Region 1')
% subplot(1,3,2); 
% quiver(y1(1,:), y1(2,:),dy1_dx ,dy2_dx, 0 )
% title('Region 2')
% subplot(1,3,3); 
% quiver(y1(1,:), y1(2,:),dy1_dx ,dy2_dx, 0 )
% title('Region 3')

