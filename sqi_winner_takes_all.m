function [ SQI ] = sqi_winner_takes_all( SQI , desition)
    if (nargin<2)
       desition = 'pessimist'; 
    end

    fields = fieldnames(SQI);
    if (strcmp(desition,'pessimist') )
        for i=1:numel(fields)
            field = fields{i};
            switch field
                case {'bSQI', 'pSQI', 'sSQI','kSQI', 'basSQI', 'eSQI','hfSQI', 'bsSQI'}  %  Abs Menor
                   aux= abs( SQI.(field) );
                   SQI.(field) = unique(SQI.(field) (aux==min(aux)));
                case 'rsdSQI'
                   aux = abs( SQI.(field) -1);
                   SQI.(field)=SQI.(field)(aux==max(aux));
                case {'pcaSQI','robpcaSQI'}
                   SQI.(field) = SQI.(field)(1);

            end

        end
    elseif (strcmp(desition,'mean') )
        for i=1:numel(fields)
            field = fields{i};
            SQI.(field) = mean( SQI.(field) );

        end
            
    end
    
    
    
end
