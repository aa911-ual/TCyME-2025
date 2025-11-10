% ============================================================
% Exercise 3 - Unbalanced Three-Phase System (Variant C)
% Week 4 Challenge
% ============================================================

clc; clear; format short;

% -------- GIVEN DATA --------
UL = 400;               % Line voltage (V)
f = 50;                 % Frequency (Hz)
w = 2*pi*f;             % Angular frequency (rad/s)

% Impedances (Ohms)
ZA = 20 + 1j*15;        % Phase A impedance
ZB = 18 - 1j*10;        % Phase B impedance
ZC_open = Inf;          % Phase C open (no load)
ZC_loaded = 25;         % Phase C when connected (purely resistive)

% -------- STEP 1: PHASE VOLTAGES --------
Uph = UL / sqrt(3);     % Phase voltage (V)
UA = Uph * exp(1j*0);                  % Phase A-N voltage
UB = Uph * exp(-1j*2*pi/3);            % Phase B-N voltage (-120°)
UC = Uph * exp(1j*2*pi/3);             % Phase C-N voltage (+120°)

fprintf('\nPhase voltage magnitude Uph = %.2f V\n', Uph);

% -------- STEP 2: C OPEN (only A and B connected) --------
IA = UA / ZA;
IB = UB / ZB;
IC = 0;                               % Open circuit

% Neutral current
IN = IA + IB + IC;

fprintf('\n---- TWO PHASES CONNECTED (C OPEN) ----\n');
fprintf('IA = %.2f ∠ %.2f° A\n', abs(IA), angle(IA)*180/pi);
fprintf('IB = %.2f ∠ %.2f° A\n', abs(IB), angle(IB)*180/pi);
fprintf('IN = %.2f ∠ %.2f° A\n', abs(IN), angle(IN)*180/pi);

% Power calculations
PA = Uph * abs(IA) * cos(angle(UA) - angle(IA));
QA = Uph * abs(IA) * sin(angle(UA) - angle(IA));
PB = Uph * abs(IB) * cos(angle(UB) - angle(IB));
QB = Uph * abs(IB) * sin(angle(UB) - angle(IB));

P_total_open = PA + PB;
Q_total_open = QA + QB;

fprintf('\nPower per phase:\n');
fprintf('P_A = %.3f kW,  Q_A = %.3f kvar\n', PA/1000, QA/1000);
fprintf('P_B = %.3f kW,  Q_B = %.3f kvar\n', PB/1000, QB/1000);
fprintf('Total: P = %.3f kW,  Q = %.3f kvar\n', P_total_open/1000, Q_total_open/1000);

% -------- STEP 3: CONNECT PHASE C WITH ZC = 25 Ω (resistive) --------
IC = UC / ZC_loaded;
IN_new = IA + IB + IC;

fprintf('\n---- THREE PHASES CONNECTED (C = 25 Ω) ----\n');
fprintf('IC = %.2f ∠ %.2f° A\n', abs(IC), angle(IC)*180/pi);
fprintf('New neutral current IN = %.2f ∠ %.2f° A\n', abs(IN_new), angle(IN_new)*180/pi);

% Power including phase C
PC = Uph * abs(IC);   % purely resistive => cosφ=1
QC = 0;

P_total_new = PA + PB + PC;
Q_total_new = QA + QB + QC;

fprintf('Total active power = %.3f kW\n', P_total_new/1000);
fprintf('Total reactive power = %.3f kvar\n', Q_total_new/1000);

% -------- STEP 4: BALANCED CASE (all 25 Ω resistive) --------
Z_bal = 25;           % All phases resistive
IA_bal = UA / Z_bal;
IB_bal = UB / Z_bal;
IC_bal = UC / Z_bal;
IN_bal = IA_bal + IB_bal + IC_bal;

P_bal = 3 * Uph * abs(IA_bal);
Q_bal = 0;

fprintf('\n---- BALANCED CASE (25 Ω each) ----\n');
fprintf('I_phase = %.2f A\n', abs(IA_bal));
fprintf('Neutral current = %.2f A\n', abs(IN_bal));
fprintf('Total power = %.3f kW\n', P_bal/1000);

% -------- STEP 5: PHASOR DIAGRAM (unbalanced case) --------
figure;
hold on; grid on; axis equal;
title('Phasor Diagram - Unbalanced System (Two-Phase and Three-Phase)');
xlabel('Real Axis'); ylabel('Imag Axis');

% Voltage reference
quiver(0,0,real(UA)/Uph,imag(UA)/Uph,'r','LineWidth',2);
quiver(0,0,real(UB)/Uph,imag(UB)/Uph,'r','LineWidth',2);
quiver(0,0,real(UC)/Uph,imag(UC)/Uph,'r','LineWidth',2);

% Currents (with C loaded)
quiver(0,0,real(IA)/max(abs([IA IB IC])),imag(IA)/max(abs([IA IB IC])),'b','LineWidth',2);
quiver(0,0,real(IB)/max(abs([IA IB IC])),imag(IB)/max(abs([IA IB IC])),'b','LineWidth',2);
quiver(0,0,real(IC)/max(abs([IA IB IC])),imag(IC)/max(abs([IA IB IC])),'b','LineWidth',2);

legend('Voltages (A,B,C)','Currents (A,B,C)','Location','bestoutside');
