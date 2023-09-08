function [values] = impulse_response(time_vector, latent_period, contraction_period)
% Returns muscle twitch values over the given time values (time_vector) and
% the latent period and contraction period. 
% Note that the timestep is in milliseconds
values = zeros(size(time_vector));


for i=1:length(time_vector)
    t = time_vector(i);
    if (t >= 0 && t < latent_period)
        values(i) = 0;
    else
        values(i) = ((t-latent_period)/contraction_period) * exp(1-((t-latent_period)/contraction_period));
    end
end

end
