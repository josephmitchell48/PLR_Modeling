function min_index = get_index(t, y)
%   Inputs: 
% t: time
% y: velocity
% Find index of initial inflextion point


acceleration = zeros(length(t));
for i = find(t>1,1)-1:length(t) - 1
    acceleration(i) = (y(i + 1) - y(i))/(t(i + 1) - t(i));
    if acceleration(i) < 0
        min_index = i;
        return;
    end
end

%[min_val, min_index] = min(acceleration);


