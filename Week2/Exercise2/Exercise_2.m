%% Week 2 - Exercise 2 (Variant C)
% Impedance and AC Circuit Analysis
% Author: Ahmad Al Kadi
% This script computes every subsection result used in the report.

clear; clc; close all;

%% ----------------------- Given data -----------------------
f  = 100;                      % Hz
w  = 2*pi*f;                   % rad/s
Vs = 80*exp(1j*deg2rad(-45)); % source phasor (RMS, cosine reference)

L1 = 50e-3;   % H
R1 = 150;     % ohm
C  = 20e-6;   % F
L2 = 80e-3;   % H
R2 = 100;     % ohm

%% 1) Element impedances in rectangular and polar form
ZL1 = 1j*w*L1;                 % j*omega*L1
ZL2 = 1j*w*L2;                 % j*omega*L2
ZC  = 1./(1j*w*C);             % 1/(j*omega*C)
ZR1 = R1;
ZR2 = R2;

ZB      = R2 + ZL2;            % series branch at node B: R2 + L2
Zseries = ZC + ZB;             % series chain after node A: C then (R2+L2)

% Display Section 1 results
disp('--- Section 1: Element impedances ---');
printRectPolar('Z_L1', ZL1);
printRectPolar('Z_L2', ZL2);
printRectPolar('Z_C ', ZC);
printRectPolar('Z_R1', ZR1);
printRectPolar('Z_R2', ZR2);
printRectPolar('Z_B ', ZB);
printRectPolar('Z_series', Zseries);

%% 2) Equivalent input impedance using admittance method
Zpar = (R1*Zseries) / (R1 + Zseries);   % R1 in parallel with Zseries
Zin  = ZL1 + Zpar;

disp('--- Section 2: Equivalent input impedance ---');
printRectPolar('Z_par', Zpar);
printRectPolar('Z_in ', Zin);

%% 3) Currents and node voltages
Is = Vs / Zin;                % source current
VA = Is * Zpar;               % node A voltage

IR1     = VA / R1;            % through R1
Iseries = VA / Zseries;       % through the right series chain
IC      = Iseries;            % same current through C
IR2L2   = Iseries;            % same current through R2+L2

VC = Iseries * ZC;
VB = Iseries * ZB;

disp('--- Section 3: Currents and node voltages ---');
printRectPolar('I_s   ', Is);
printRectPolar('V_A   ', VA);
printRectPolar('I_R1  ', IR1);
printRectPolar('I_ser ', Iseries);
printRectPolar('V_C   ', VC);
printRectPolar('V_B   ', VB);

% KCL sanity check at node A
chk = IR1 + Iseries;
fprintf('Check IR1 + Iseries equals Is -> %.6f%+.6fi A\n', real(chk), imag(chk));

%% 4) Phase angle between source voltage and current, and powers
phi_deg = rad2deg(angle(Is)) - rad2deg(angle(Vs));
pf = cosd(phi_deg);

S = Vs * conj(Is);            % complex power using RMS phasors
P = real(S); Q = imag(S); Sabs = abs(S);

disp('--- Section 4: Phase and powers ---');
fprintf('Phase(I,V) = %.2f deg (negative means current lags)\n', phi_deg);
fprintf('Power factor = %.3f (lagging)\n', pf);
fprintf('P = %.2f W, Q = %.2f var, |S| = %.2f VA\n', P, Q, Sabs);

%% 5) Frequency where input becomes purely resistive  Im{Zin(f)} = 0
Zin_f = @(f) 1j*2*pi*f*L1 + ...
    ( R1.*( 1./(1j*2*pi*f*C) + R2 + 1j*2*pi*f*L2 ) ) ./ ...
    ( R1 + 1./(1j*2*pi*f*C) + R2 + 1j*2*pi*f*L2 );

funImag = @(f) imag(Zin_f(f));

% robust solve using a bracket
f_bracket = [50 200];      % Hz
f_res = fzero(funImag, f_bracket);

disp('--- Section 5: Purely resistive frequency ---');
fprintf('f_purely_resistive = %.2f Hz\n', f_res);
Zin_res = Zin_f(f_res);
printRectPolar('Z_in at f_res', Zin_res);

%% --------------- Helper function for printing ---------------
function printRectPolar(name, Z)
    mag = abs(Z); ang = rad2deg(angle(Z));
    fprintf('%s = %.3f%+.3fj ohm   |Z|=%.3f  angle=%.3f deg\n', ...
            name, real(Z), imag(Z), mag, ang);
end
