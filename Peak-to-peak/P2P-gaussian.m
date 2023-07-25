%% Calculate Double Gaussian Curve
% Save cross-section intensity from Fiji. Normalize and center the curve.
% Save as CSV without column names. C1: Distance in nm. C2: Normalized intensity.
% Specify the file path and name
clear
file = 'P2P-2-b-norm.csv';

% Import the CSV file
data = readmatrix(file);

% Display the data
disp('Data:');
disp(data);

% Define the Gaussian function with two peaks
gaussian = @(params, x) params(1)*exp(-(x-params(2)).^2/(2*params(3)^2)) + ...
                        params(4)*exp(-(x-params(5)).^2/(2*params(6)^2));

% Initial guess for the parameters [amplitude1, center1, width1, amplitude2, center2, width2]
initial_params = [1, -30, 20, 1, 30, 20];

% Perform the curve fitting
fit_params = lsqcurvefit(gaussian, initial_params, data(:, 1), data(:, 2));

% Generate fitted curve using the fitted parameters
x_values = linspace(min(data(:, 1)), max(data(:, 1)), 1000);
fitted_curve = gaussian(fit_params, x_values);

%% Plot the original data and the fitted curve
figure('Position', [100, 100, 300, 500]);;
plot(data(:, 1), data(:, 2), 'k.', 'MarkerSize', 10, 'DisplayName', 'Original Data');
hold on;
plot(x_values, fitted_curve, 'b-', 'LineWidth', 2, 'DisplayName', 'Fitted Curve');
xlim([-150, 150]); 
xlabel({'Transverse Position', '(nm)'});
ylabel('Normalized Intensity');
set(gca, 'FontSize', 18);
%title('Gaussian Curve Fitting');
%legend('Location', 'best');

% Remove top and right spines
ax = gca;
ax.Box = 'off';
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'left';
ax.Color = 'white';

% Set x-axis ticks
ax.XTick = [-100, 0, 100];

% Set y-axis ticks
ax.YTick = [0, 0.2, 0.4, 0.6, 0.8, 1];
