function [ basSQI ] = calc_basSQI( f, power_spec )
%CALC_BASSQI Ratio between power of very low frecuencies and total power
    P_vlf = sum(power_spec(f < 1,:));  % Power: very low frequency
    P_total = sum(power_spec(f < 40,:));

    if (P_total)
        basSQI = 1 - P_vlf./P_total;
    else
        basSQI = zeros( 1,size(power_spec,2) ); 
    end
end

