function [ pSQI ] = calc_pSQI( f, power_spec )
    P_lf = sum(power_spec(f > 5 & f < 15,:));
    P_hf = sum(power_spec(f > 5 & f < 40,:));

    if (P_lf)
        pSQI = P_hf./P_lf; 
    else
        pSQI = ones(1,size(power_spec,2))*realmax; 
    end
end

