%% Exercise 1 - From Sinusoids to Phasors (Variant C)
% Ahmad Al Kadi - Week 2
% This script verifies the analytical results using MATLAB plots.

clear; clc; close all;

% ---------------------------------------------------------------
% Given data
% ---------------------------------------------------------------
w = 628;                 % Angular frequency [rad/s]
f = w/(2*pi);            % Frequency [Hz]
T = 1/f;                 % Period [s]
t = 0:1e-4:T;            % Time vector (one full period)

% Voltages and current (time-domain expressions)
v1 = 200 * sin(w*t - deg2rad(60));   % v1(t)
v2 = 150 * sin(w*t + deg2rad(90));   % v2(t)
i  = 8   * cos(w*t + deg2rad(120));  % i(t)

% ---------------------------------------------------------------
% Phasor addition check
% ---------------------------------------------------------------
v_sum = v1 + v2;          % Resultant voltage (time-domain)
V1_ph = 200*exp(1j*deg2rad(-150));
V2_ph = 150*exp(1j*deg2rad(0));
Vsum_ph = V1_ph + V2_ph;
mag_Vsum = abs(Vsum_ph);
ang_Vsum = rad2deg(angle(Vsum_ph));

fprintf('Resultant phasor: |Vsum| = %.3f V,  angle = %.3f deg\n', ...
        mag_Vsum, ang_Vsum);

% ---------------------------------------------------------------
% Plot voltages
% ---------------------------------------------------------------
figure('Name','Voltages','Color','w');
plot(t, v1, 'r', 'LineWidth', 1.3); hold on;
plot(t, v2, 'b', 'LineWidth', 1.3);
plot(t, v_sum, 'k', 'LineWidth', 1.4);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('v_1(t), v_2(t), and v_1(t)+v_2(t)');
legend('v_1(t)', 'v_2(t)', 'v_1(t)+v_2(t)', 'Location', 'best');
grid on;

% ---------------------------------------------------------------
% Instantaneous power p(t) = v1(t)*i(t)
% ---------------------------------------------------------------
p = v1 .* i;

figure('Name','Instantaneous Power','Color','w');
plot(t, p, 'm', 'LineWidth', 1.3);
xlabel('Time (s)');
ylabel('Power (W)');
title('Instantaneous Power  p(t) = v_1(t) \times i(t)');
grid on;

% ---------------------------------------------------------------
% Average power check (should be zero)
% ---------------------------------------------------------------
P_avg = mean(p);
fprintf('Average Power = %.4f W\n', P_avg);
