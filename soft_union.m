function [ D ] = soft_union( A, B , win_rad )
%SOFT_UNION Summary of this function goes here
%   Detailed explanation goes here

    C = union(A,B);
    
    for i=1:length(C)
       aux = C( ( C(i)-win_rad < C ) & ( C < C(i)+win_rad) )
       D(i) = prctile(aux,50);
    end
    
    D = unique(D)  


end

