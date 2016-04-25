function res = sngstatsCRT(splitRes)
%CRT Does some basic data transformation to choice reaction time tasks.
%
%   Basically, the supported tasks are as follows:
%     15-17. CRT
%   The output table contains 6 variables, called ACC, MRT, VRT, v, a, Ter.

%By Zhang, Liang. 04/13/2016. E-mail:psychelzh@gmail.com

%coupleVars are formatted out variables.
varPref = {'ACC', 'MRT'};
varSuff = {''};
delimiter = '';
coupleVars = strcat(repmat(varPref, 1, length(varSuff)), delimiter, repelem(varSuff, 1, length(varPref)));
%further required variables.
singletonVars = {'VRT', 'v', 'a', 'Ter'};
%Out variables names are composed by three part.
outvars = [coupleVars, singletonVars];
if ~istable(splitRes{:}) || isempty(splitRes{:})
    res = {array2table(nan(1, length(outvars)), ...
        'VariableNames', outvars)};
    return
end
RECORD = splitRes{:}.RECORD{:};
%Cutoff RTs: eliminate RTs that are too fast (<100ms).
RECORD(RECORD.RT < 100 & RECORD.RT > 0, :) = [];
%Removed trials without response.
RECORD(RECORD.Resp == 0, :) = [];
%Remove NaN trials.
RECORD(isnan(RECORD.ACC), :) = [];
%RT and ACC.
ACC = mean(RECORD.ACC);
MRT = mean(RECORD.RT(RECORD.ACC == 1));
%Standard deviation of RTs.
VRT = std(RECORD.RT(RECORD.ACC == 1));
%Calculate variables defined by a diffusion model.
[v, a, Ter] = EZdif(ACC, MRT / 10 ^ 3, VRT ^ 2 / 10 ^ 6);
res = {table(ACC, MRT, VRT, v, a, Ter)};