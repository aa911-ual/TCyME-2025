% Exercise 3.1 - Theoretical Output Based on Faraday's Law
% Variant C: AC Generator

clear; clc;

% ----------------------------
% Given parameters
% ----------------------------
N = 200;              % number of turns
A = 0.04 * 0.06;      % coil area in m^2 (4 cm x 6 cm)
speed_rpm = [1000 2000 3000];   % speed range in rpm

% Expected field (to match spec 20-50 V peak)
B_low  = 0.331;       % Tesla (gives ~50 V at 3000 rpm)
B_high = 0.399;       % Tesla (gives ~20 V at 1000 rpm)

% ----------------------------
% Helper function: EMF amplitude
% ----------------------------
% Formula: E_peak = N * A * B * (2*pi*n/60)

E_peak_low  = N * A * B_low  * (2*pi*speed_rpm/60);
E_peak_high = N * A * B_high * (2*pi*speed_rpm/60);

% RMS values
E_rms_low  = E_peak_low  / sqrt(2);
E_rms_high = E_peak_high / sqrt(2);

% Frequencies
f = speed_rpm / 60;   % Hz

% ----------------------------
% Display results
% ----------------------------
fprintf('--- Theoretical Generator Output (Faraday) ---\n');
fprintf('Coil: %d turns, Area = %.4f m^2\n', N, A);
fprintf('Speeds: %d - %d rpm  -->  %.2f - %.2f Hz\n\n', ...
        speed_rpm(1), speed_rpm(end), f(1), f(end));

for k = 1:length(speed_rpm)
    fprintf('At %4d rpm (f = %.2f Hz):\n', speed_rpm(k), f(k));
    fprintf('  B = %.3f T  -->  E_peak = %.2f V,  E_rms = %.2f V\n', ...
             B_low,  E_peak_low(k),  E_rms_low(k));
    fprintf('  B = %.3f T  -->  E_peak = %.2f V,  E_rms = %.2f V\n\n', ...
             B_high, E_peak_high(k), E_rms_high(k));
end
