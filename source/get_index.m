function index = get_index(t, y)
%   Inputs: 
% t: time
% y: velocity
% Find index of initial inflextion point

index = 0;

acceleration = y/t;
for i = 1:length(acceleration) - 1
   if (abs(acceleration(i+1)/acceleration(i)) > 3) && (acceleration(i+1)/acceleration(i) ~= 0) && (isinf(acceleration(i+1)/acceleration(i)) == false)
        index = i;
        return;
    end

end

