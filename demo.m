clc
clear
close all
rng default
load dataset.mat

% 模型设定
K = 10;
XDate = HighFreqDate;
YDate = LowsFreqDate;
nMarket = length(XNames);
zt = zeros((nLowsFreqSample-K)*22, nMarket);
sigmat = zeros((nLowsFreqSample-K)*22, nMarket);
Xt = zeros((nLowsFreqSample-K)*22, nMarket);
Xidx = zeros((nLowsFreqSample-K)*22, nMarket);
estMdl = cell(1, nMarket);

% 描述性统计
rt = X;
descripResult(:, 1) = mean(rt)';
descripResult(:, 2) = std(rt)';
descripResult(:, 3) = median(rt)';
descripResult(:, 4) = min(rt)';
descripResult(:, 5) = max(rt)';
descripResult(:, 6) = skewness(rt)';
descripResult(:, 7) = kurtosis(rt)';
descripResultTab = array2table(descripResult, "VariableNames", ...
    ["Mean", "Std", "Median", "Min", "Max", "Skew", "Kurt"]);
disp(descripResultTab)

% 边缘分布拟合，基于GARCHMIDAS模型
for idx = 1:nMarket
    tic
    [estMdl{idx}, sigmat(:, idx), zt(:, idx), Xt(:, idx), Xidx(:, idx), XDateMat(:, idx)] = ...
        GARCHmidasFit(X(:, idx), Y, 'nLags', K, 'XDate', XDate, 'YDate', YDate);
    disp(estMdl{idx}.resultTab)
    toc
end
ut = normcdf(zt);
ut(ut<0.001) = 0.001;
ut(ut>0.999) = 0.999;


