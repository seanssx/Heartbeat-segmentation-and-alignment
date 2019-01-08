% Copyright (c) S.S. XU (2018)
% mailto: sean.xu@connect.polyu.hk

function featureMat = findFeatureMat()
featureMat = [];
featureMat = [featureMat;findECGMat(234)]; % ECG recordings (e.g., 234) in MIT-BIH Arrhythmia Database
end

function res = findECGMat(record)
str1 = strcat(int2str(record),'annotations.txt');
str1 = strcat('../Sean ECG_findFeature/RR record/RR',str1);
data = importdata(str1);

str2 = strcat(int2str(record),'m.mat');
str2 = strcat('../Sean ECG_findFeature/Raw Signal/',str2);
load(str2);

ECG1 = val(1,:);

winLen = 417; % Dimension of feature vector
middleI = (winLen+1)/2; % Centre of feature vector
side = (winLen-1)/2; % Length of left part of feature vector
res = [];
for i = 2:length(data)-1
    % Discard the first marker bacause it is a start point; 
    % Discaed the second and the last beat marker.
    ecg_mat = zeros(1, winLen); % Feature vector of a single beat
    peak = data(i); % Current peak location;
    left = floor((data(i-1) + peak)/2);% Left margin of current beat;
    right = floor((peak + data(i+1))/2); % Right margin of current beat;
    startI = 1; % Start point of writing 
    currentECG = left;% Start point of reading
    if (peak - left) < side
        startI = middleI - (peak-left);
    else
        currentECG = peak - side;
    end
    for j = startI:winLen
        if currentECG > right
            % Reading ends here.
            break;
        end
        ecg_mat(j) = ECG1(currentECG);
        currentECG = currentECG + 1;
    end
    res = [res;ecg_mat];
end
end