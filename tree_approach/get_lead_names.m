function [ lead_names ] = get_lead_names( ECG_header )
%GET_LEADS Summary of this function goes here
%   Detailed explanation goes here

    str_aux = regexprep(cellstr(ECG_header.desc), '\W*(\w+)\W*', '$1');
    lead_names = regexprep(str_aux, '\W', '_');

    [str_aux2, ~ , aux_idx] = unique( lead_names );
    aux_val = length(str_aux2);
            
    if( aux_val ~= ECG_header.nsig )
        for ii = 1:aux_val
            bAux = aux_idx==ii;
            aux_matches = sum(bAux);
            if( sum(bAux) > 1 )
                lead_names(bAux) = strcat( lead_names(bAux), repmat({'v'}, aux_matches,1), cellstr(num2str((1:aux_matches)')) );
            end
        end
    end
    
    lead_names = cellstr(lead_names);
end

