% ===============================================
% Exercise 1 - Balanced Three-Phase Star System
% Variant C (Week 4)
% ===============================================

clc; clear;

% ----- GIVEN DATA -----
Uph = 220;             % Phase voltage (V)
f = 50;                % Frequency (Hz)
P3 = 15000;            % Total three-phase active power (W)
pf1 = 0.8;             % Initial power factor (lagging)

% ----- STEP 1: LINE VOLTAGE -----
UL = sqrt(3) * Uph;    % Line voltage (V)

% ----- STEP 2: LINE AND PHASE CURRENT -----
IL = P3 / (sqrt(3) * UL * pf1);   % Line current (A)
Iph = IL;                         % Star connection => same current per phase

% ----- STEP 3: IMPEDANCE PER PHASE -----
Zph = Uph / Iph;      % Impedance magnitude (Ohms)
phi1 = acos(pf1);     % Power factor angle (radians)

% ----- STEP 4: RESISTANCE AND REACTANCE -----
R = Zph * cos(phi1);  % Resistance (Ohms)
XL = Zph * sin(phi1); % Inductive reactance (Ohms)
L = XL / (2*pi*f);    % Inductance (H)

% ----- STEP 5: POWER CALCULATIONS -----
Pph = Uph * Iph * pf1;            % Active power per phase (W)
Qph = Uph * Iph * sin(phi1);      % Reactive power per phase (var)
Sph = Uph * Iph;                  % Apparent power per phase (VA)
Q3 = 3 * Qph;                     % Total reactive power (var)

% ----- STEP 6: POWER FACTOR CORRECTION TO 0.95 -----
pf2 = 0.95;                       % Target power factor
phi2 = acos(pf2);
QC3 = P3 * (tan(phi1) - tan(phi2));   % Total vars to be compensated (var)
QCph = QC3 / 3;                       % Per phase vars (var)
C_Y = QCph / (2*pi*f*Uph^2);          % Capacitance per phase (F)
C_Delta = QCph / (2*pi*f*UL^2);       % Equivalent if connected in delta (F)

% ----- STEP 7: CURRENT AFTER CORRECTION -----
IL2 = P3 / (sqrt(3) * UL * pf2);      % New line current (A)
reduction = (IL - IL2) / IL * 100;    % % reduction in current

% ----- DISPLAY RESULTS -----
fprintf('\n========= RESULTS =========\n');
fprintf('Line voltage (UL): %.2f V\n', UL);
fprintf('Line current before correction (IL1): %.2f A\n', IL);
fprintf('Phase impedance: %.2f Ohm\n', Zph);
fprintf('R = %.2f Ohm, XL = %.2f Ohm, L = %.4f H\n', R, XL, L);
fprintf('Total reactive power Q3φ = %.2f kvar\n', Q3/1000);
fprintf('Capacitance per phase (star) C_Y = %.1f µF\n', C_Y*1e6);
fprintf('Capacitance per phase (delta) C_Δ = %.1f µF\n', C_Delta*1e6);
fprintf('Line current after correction (IL2): %.2f A\n', IL2);
fprintf('Current reduction = %.1f %%\n', reduction);
fprintf('============================\n');

% ----- OPTIONAL: PHASOR DIAGRAM -----
% This simple plot helps visualize current before and after correction
figure;
quiver(0,0,1,0,'r','LineWidth',2); hold on; % Voltage reference
quiver(0,0,cos(phi1),-sin(phi1),'b','LineWidth',2);
quiver(0,0,cos(phi2),-sin(phi2),'g','LineWidth',2);
legend('Voltage','Current before PF correction (0.8 lag)','Current after PF correction (0.95 lag)');
title('Phasor diagram of current before and after correction');
axis equal; grid on;
