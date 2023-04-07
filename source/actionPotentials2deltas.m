function [deltas] = actionPotentials2deltas(voltages)
%actionPotentials2deltas: this function takes the timerseries voltage of
%the nerve membrance and converts to dirac delta functions
%   Each nerve impulse corresponds to a '1' at the time point it passes a
%   threshold in the 'deltas' output variable
% Input: 
% voltages - 1D vector of timeseries voltages of the neuron membrane 
% Output: 
% deltas - delta (1) at times corresponding to the times where voltage
% passes a threshold

threshold = 0.75*max(voltages); %voltage threshold to trigger a muscle twitch
below_threshold = true; 
deltas = zeros(length(voltages),1);

for i = 1:length(voltages)
    if voltages(i)>threshold && below_threshold
        deltas(i) = 1;
        below_threshold = false;
    elseif voltages(i)<threshold && below_threshold==false
        below_threshold=true;
    end
end

for i = 1:length(deltas)
    if deltas(i) ==1
        deltas(i) = 0;
        break;
    end
end
end