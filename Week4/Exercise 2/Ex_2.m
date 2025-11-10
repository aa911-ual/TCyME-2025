% ===============================================
% Exercise 2 - Balanced Three-Phase System (Delta)
% Variant C - Week 4 Challenge
% ===============================================

clc; clear;

% ---------- GIVEN DATA ----------
UL = 400;          % Line voltage (V)
f = 50;            % Frequency (Hz)
P_rated = 20000;   % Rated mechanical power (W)
eta = 0.90;        % Efficiency
pf = 0.85;         % Power factor (lagging)

% ---------- STEP 1: ELECTRICAL INPUT POWER ----------
P_in = P_rated / eta;      % Electrical input power (W)

% ---------- STEP 2: LINE CURRENT (DELTA) ----------
IL_delta = P_in / (sqrt(3) * UL * pf);   % Line current (A)

% ---------- STEP 3: PHASE CURRENT (DELTA) ----------
Iph_delta = IL_delta / sqrt(3);          % Phase current (A)
Uph_delta = UL;                          % In delta, phase voltage = line voltage

% ---------- STEP 4: PHASE IMPEDANCE ----------
Z_delta = Uph_delta / Iph_delta;         % Phase impedance (Ohms)
phi = acos(pf);                          % Power factor angle (rad)
R_delta = Z_delta * cos(phi);            % Resistance per phase (Ohms)
XL_delta = Z_delta * sin(phi);           % Inductive reactance (Ohms)
L_delta = XL_delta / (2 * pi * f);       % Inductance (H)

% ---------- STEP 5: POWER CHECKS ----------
Q3_delta = sqrt(3) * UL * IL_delta * sin(phi);    % Total reactive power (var)
S3_delta = sqrt(P_in^2 + Q3_delta^2);             % Total apparent power (VA)

% ---------- STEP 6: STAR CONNECTION COMPARISON ----------
Uph_star = UL / sqrt(3);                 % Phase voltage in star (V)
Iph_star = Uph_star / Z_delta;           % Phase current in star (A)
IL_star = Iph_star;                      % In star: IL = Iph
P3_star = sqrt(3) * UL * IL_star * pf;   % Power in star (W)

% ---------- STEP 7: STARTING CURRENT (DOL and STAR START) ----------
IL_start_delta = sqrt(3) * UL / Z_delta; % Direct-On-Line start current (A)
IL_start_star = (UL / sqrt(3)) / Z_delta; % Star start current (A)

% ---------- DISPLAY RESULTS ----------
fprintf('\n=========== RESULTS (DELTA CONNECTION) ===========\n');
fprintf('Electrical input power P_in = %.2f kW\n', P_in / 1000);
fprintf('Line current (delta) IL_Δ = %.2f A\n', IL_delta);
fprintf('Phase current (delta) Iph_Δ = %.2f A\n', Iph_delta);
fprintf('Phase impedance |ZΔ| = %.2f Ohm\n', Z_delta);
fprintf('RΔ = %.2f Ohm, XLΔ = %.2f Ohm, LΔ = %.4f H\n', R_delta, XL_delta, L_delta);
fprintf('Reactive power Q3φ = %.2f kvar\n', Q3_delta / 1000);
fprintf('Apparent power S3φ = %.2f kVA\n', S3_delta / 1000);

fprintf('\n----------- COMPARISON WITH STAR CONNECTION -----------\n');
fprintf('Line current (star) IL_Y = %.2f A\n', IL_star);
fprintf('Input power (star) P3φ,Y = %.2f kW\n', P3_star / 1000);
fprintf('Current ratio (Y/Δ) = %.3f\n', IL_star / IL_delta);
fprintf('Power ratio (Y/Δ)   = %.3f\n', P3_star / P_in);

fprintf('\n----------- MOTOR STARTING CURRENT -----------\n');
fprintf('DOL start current (Δ) = %.2f A\n', IL_start_delta);
fprintf('Star start current (Y) = %.2f A\n', IL_start_star);
fprintf('Reduction factor = %.3f (≈ 1/3)\n', IL_start_star / IL_start_delta);
fprintf('========================================================\n');

% ---------- OPTIONAL PHASOR DIAGRAM ----------
figure;
quiver(0,0,1,0,'r','LineWidth',2); hold on; % Voltage reference
quiver(0,0,cos(phi),-sin(phi),'b','LineWidth',2);
title('Phasor Diagram - Delta Connected Motor');
legend('Voltage','Current (lagging 31.8°)','Location','southwest');
xlabel('Real Axis'); ylabel('Imag Axis');
axis equal; grid on;
