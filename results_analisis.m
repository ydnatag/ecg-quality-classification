function [acc_sqi unacc_sqi] = results_analisis (dataset)
    PATH = ['./results/' dataset '/'];

    if ( exist(['./records/' dataset '/RECORDS-acceptable'],'file') )
        f = fopen(['./records/' dataset '/RECORDS-acceptable']);
        files = textscan(f,'%s');
        fclose(f);
    else
        error('No existe el archivo');
    end
    files = files{1}';
    files= strcat([PATH 'sqi_'],files);
    files= strcat(files,'.mat');
    acceptable = cellfun(@load,files);
    acceptable = acceptable';
    if ( exist(['./records/' dataset '/RECORDS-unacceptable'],'file') )
        f = fopen(['./records/' dataset '/RECORDS-unacceptable']);
        files = textscan(f,'%s');
        fclose(f);
    else
        error('No existe el archivo');
    end
    files = files{1}';
    files= strcat([PATH 'sqi_'],files);
    files= strcat(files,'.mat');
    unacceptable = cellfun(@load,files);
   
    acc_sqi =  arrayfun(@(x) acceptable(x).sqi,1:numel(acceptable));
    unacc_sqi =  arrayfun(@(x) unacceptable(x).sqi,1:numel(unacceptable));
    
    clear acceptable unacceptable files;

    fields = fieldnames(acc_sqi);
    
    %acc = cellfun(@(x) sqi_winner_takes_all(x,'pessimist'),acc_sqi);
    %unacc = cellfun(@(x) sqi_winner_takes_all(x,'pessimist'),unacc_sqi);
    
    
    acc = [];
    unacc = [];
    for i=1:12
        acc = [acc arrayfun(@(x) sqi_take_lead(x,i),acc_sqi)];
        unacc = [unacc arrayfun(@(x) sqi_take_lead(x,i),unacc_sqi)];
    end
    
    clear acc_sqi unacc_sqi;
    
    plotSpaces(acc,unacc,fields);
    %cellfun(@(x) plotHistograms(acc,unacc,x,100),fields);
end    

function ret =structarray2array(structarray,field)
    ret =  arrayfun(@(x) structarray(x).(field),1:numel(structarray));
end

function sqi = sqi_take_lead (sqi , lead )
    fields = fieldnames(sqi);
    for i=1:numel(fields)
        aux = sqi.(fields{i});
        sqi.(fields{i}) = aux(lead);
    end
end


function plotHistograms( acc,unacc,fields,dots)
    acc = structarray2array(acc,fields);
    unacc= structarray2array(unacc,fields);
    
    acc = acc(abs(acc)<inf);
    unacc = unacc(abs(unacc)<inf);

    xmin= min([min(acc) min(unacc)]);
    xmax= max([max(acc) max(unacc)]);
    
    x = linspace(xmin,xmax,dots);
    
    
    figure('Name',fields);
    [an,ax] = hist(acc,x);
    [un,ux] = hist(unacc,x);

    plot(ax,an/sum(an));
    hold on;
    plot(ux,un/sum(un),'r');
    hold off;
end

function plotSpaces (acc,unacc,fields)
    num = size(fields,1);
    
    c =combnk(1:num,2);
    
    
    for i=1:size(c,1)
        acc1 = structarray2array(acc,fields{c(i,1)});
        acc2 = structarray2array(acc,fields{c(i,2)});
        unacc1 = structarray2array(unacc,fields{c(i,1)});
        unacc2 = structarray2array(unacc,fields{c(i,2)});

%        figure('Name',[fields{c(i,1)} ' vs ' fields{c(i,2)}]);
        plot(acc1,acc2,'o');
        hold on;
        plot(unacc1,unacc2,'ro');
        hold off;
        xlabel(fields{c(i,1)});
        ylabel(fields{c(i,2)});
    end
end
