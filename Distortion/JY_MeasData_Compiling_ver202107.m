% Measurement Error Compiling

%% ===== Data Compiling =====

% Use the first 3 sections to compile RMS error data from separate samples
% Then, run the following code to get RMS curve with SD shading.

%% Initialization: Run this section once
clear;
measData = struct([]);

%% Compiling: Run this section N times, for each of the N samples

% Step 1: Load saved workspace from MasterScript
% Step 2: Edit the following parameters and run this section
n = 6
data_name = 'Sample'

measData(n).Name = data_name;
measData(n).measResults = imgPair.measResults;

%% Saving: Run this section once
clearvars -except measData
save measData_compiled.mat;

%% ===== Data Visualization =====
clear; clc; close all;
load measData_compiled.mat;

%% individual plots
figure(1); clf;

panel_config = [3 2];

movavgWindow = 10;
do_movavg = 0;
pixelWidth_pre = 0.08125; % DNA PAINT: 0.00395142. Confocal: 0.08125

axis_limits = [0 20 0 1.5];

for i = 1:length(measData)
    
    % Basic calc from original script
    measResults = measData(i).measResults;
    xmin = 1;%in pixels
    xmax = size(measResults,1);
    xvals = [xmin:xmax];
    notNaNindices = xvals(~isnan(measResults([xmin:xmax],3)));
    xvals = notNaNindices * pixelWidth_pre;
    
    measLength = xvals;
    RMSerror = measResults(notNaNindices,3)*pixelWidth_pre;
    
    if do_movavg
        RMSerror = movmean(RMSerror,movavgWindow);
    end
    
    subplot(panel_config(1),panel_config(2),i);
    plot( measLength, RMSerror, 'LineWidth', 2)
    
    axis(axis_limits);
end

%% AVG and STD plot

num_xval = 252;
measResults_all = zeros(length(measData),num_xval);

for i = 1:length(measData)
    
    measResults = measData(i).measResults;
    xmin = 1;%in pixels
    xmax = size(measResults,1);
    xvals = [xmin:xmax];
    notNaNindices = xvals(~isnan(measResults([xmin:xmax],3)));
    xvals = notNaNindices * pixelWidth_pre;
    
    measLength = xvals(1:num_xval);
    RMSerror = measResults(notNaNindices,3)*pixelWidth_pre;
    
    if do_movavg
        RMSerror = movmean(RMSerror,movavgWindow);
    end
    
    measResults_all(i,:) = RMSerror(1:num_xval);
end

measResults_AVG = mean(measResults_all,1);
measResults_STD = std(measResults_all,0,1);

figure(2); clf;
errorbar(measLength, measResults_AVG, measResults_STD);
axis(axis_limits);

figure(3);clf;
h = shadedErrorBar(measLength, measResults_AVG, measResults_STD,'lineprops','b');
set(h.mainLine,'LineWidth',2)
axis(axis_limits);
xlabel('Measurement Length (\mum)','fontsize',12)
ylabel('RMS Error (\mum)','fontsize',12)
    