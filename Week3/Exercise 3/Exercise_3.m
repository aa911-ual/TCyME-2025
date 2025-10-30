% Week 3 - Exercise 3 - Variant C
% Power analysis + two-stage PF correction + voltage regulation
clear; clc;

% Supply
U = 220;            % RMS V
f = 60;  w = 2*pi*f;

% Loads
Z1 = 8 + 12j;       % Load 1 (impedance)
P2 = 4000; pf2 = 0.85;   % Load 2 (P,pf)
P3 = 1500;               % Load 3 (resistive)
S4_va = 6000; pf4 = 0.70;% Load 4 (S,pf)

% ---------- Load 1 from impedance ----------
I1 = U / Z1;
S1 = U * conj(I1);          % VA
P1 = real(S1); Q1 = imag(S1);
pf1 = P1/abs(S1);

% ---------- Load 2 from P and pf ----------
S2_abs = P2/pf2;
Q2 = sqrt(S2_abs^2 - P2^2);
S2 = P2 + 1j*Q2;

% ---------- Load 3 resistive ----------
Q3 = 0;
S3 = P3 + 1j*Q3;

% ---------- Load 4 from S and pf ----------
P4 = S4_va*pf4;
Q4 = sqrt(S4_va^2 - P4^2);
S4 = P4 + 1j*Q4;

% ---------- Totals (Boucherot) ----------
Stot = S1 + S2 + S3 + S4;
Ptot = real(Stot);
Qtot = imag(Stot);
Stot_abs = abs(Stot);
pf_tot = Ptot/Stot_abs;

% ---------- Two-stage power-factor correction ----------
pf_t1 = 0.92;     % target stage 1
pf_t2 = 0.98;     % target stage 2

Qt1 = Ptot * tan(acos(pf_t1));      % desired Q at 0.92
Qt2 = Ptot * tan(acos(pf_t2));      % desired Q at 0.98

Qc1 = Qtot - Qt1;                   % vars stage 1
Qc2 = Qtot - Qt2 - Qc1;             % extra vars stage 2

C1 = Qc1 / (w*U^2);                 % F
C2 = Qc2 / (w*U^2);                 % F
Ctot = C1 + C2;

% ---------- Voltage regulation ----------
Zline = 0.3 + 0.4j;                 % ohm

S_before = Stot;
I_before = conj(S_before)/U;
dU_before = I_before * Zline;
Uload_before = U - dU_before;
VR_before = 100*(U - abs(Uload_before))/U;

S_after = Ptot + 1j*Qt2;
I_after = conj(S_after)/U;
dU_after = I_after * Zline;
Uload_after = U - dU_after;
VR_after = 100*(U - abs(Uload_after))/U;

% ---------- Print results ----------
fprintf('--- Individual Loads ---\n');
fprintf('L1: P=%.2f W  Q=%.2f var  |S|=%.2f VA  pf=%.3f\n', P1,Q1,abs(S1),pf1);
fprintf('L2: P=%.2f W  Q=%.2f var  |S|=%.2f VA  pf=%.2f\n', P2,Q2,S2_abs,pf2);
fprintf('L3: P=%.2f W  Q=0.00 var  |S|=%.2f VA  pf=1.00\n', P3,abs(S3));
fprintf('L4: P=%.2f W  Q=%.2f var  |S|=%.2f VA  pf=%.2f\n\n', real(S4),imag(S4),abs(S4),pf4);

fprintf('--- Totals ---\n');
fprintf('P_tot=%.2f W  Q_tot=%.2f var  |S_tot|=%.2f VA  pf_tot=%.3f\n\n', ...
        Ptot,Qtot,Stot_abs,pf_tot);

fprintf('--- PF Correction ---\n');
fprintf('Stage1 to 0.92:  Qc1=%.2f var  C1=%.2e F (%.1f uF)\n', Qc1, C1, C1*1e6);
fprintf('Stage2 to 0.98:  Qc2=%.2f var  C2=%.2e F (%.1f uF)\n', Qc2, C2, C2*1e6);
fprintf('Total C = %.2e F (%.1f uF)\n\n', Ctot, Ctot*1e6);

fprintf('--- Voltage Regulation ---\n');
fprintf('Before: |U_load|=%.2f V  VR=%.2f%%\n', abs(Uload_before), VR_before);
fprintf('After : |U_load|=%.2f V  VR=%.2f%%\n', abs(Uload_after), VR_after);
fprintf('Improvement: dVR=%.2f points\n', VR_before - VR_after);

% ---------- Bar plot (saved figure) ----------
figure;
bar([abs(Uload_before) abs(Uload_after)]);
set(gca,'XTickLabel',{'Before','After'});
ylabel('|U_{load}| [V]');
title('Voltage before vs after PF correction');
grid on;
