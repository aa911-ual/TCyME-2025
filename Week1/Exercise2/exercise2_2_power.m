% exercise2_2_power.m  -- Instantaneous power for R, L, C (Variant C)

% ---------- Given source ----------
Vm    = 80;           % V (peak)
omega = 628;          % rad/s  (~100 Hz)
f     = omega/(2*pi); % Hz
T     = 1/f;          % period (s)

% ---------- Element values ----------
R = 40;          % ohm
L = 0.1;         % H
C = 50e-6;       % F  (50 microfarads = 50 x 10^-6 F)

% ---------- Currents from Section 2.1 ----------
IR_peak = Vm/R;                % 2.000 A
IL_peak = Vm/(omega*L);        % 1.274 A
IC_peak = Vm*(omega*C);        % 2.512 A

% Phase shifts (rad): R=0, L=-pi/2, C=+pi/2
phi_R = 0;
phi_L = -pi/2;
phi_C = +pi/2;

% ---------- Time vector (two periods for clear plots) ----------
N = 4000;                            % samples
t = linspace(0, 2*T, N);             % 0 .. 2T

% ---------- Voltages and currents ----------
v  = Vm * sin(omega*t);
iR = IR_peak * sin(omega*t + phi_R);
iL = IL_peak * sin(omega*t + phi_L);
iC = IC_peak * sin(omega*t + phi_C);

% ---------- Instantaneous powers p(t) = v(t) * i(t) ----------
pR = v .* iR;
pL = v .* iL;
pC = v .* iC;

% ---------- Analytical reference values ----------
PR_avg_theory = (Vm^2)/(2*R);            % 80 W
PL_amp_theory = (Vm*IL_peak)/2;          % 50.96 W
PC_amp_theory = (Vm*IC_peak)/2;          % 100.48 W

% ---------- Numerical averages over one period (last T segment) ----------
idx = t >= T & t <= 2*T;                 % select one full period
PR_avg_num = mean(pR(idx));
PL_avg_num = mean(pL(idx));
PC_avg_num = mean(pC(idx));

% ---------- Display results ----------
fprintf('--- Instantaneous Power Results (Variant C) ---\n');
fprintf('Resistor:   p_R(t) = 80*(1 - cos(1256 t)) W\n');
fprintf('  Average power (theory)   = %.2f W\n', PR_avg_theory);
fprintf('  Average power (numeric)  = %.2f W\n\n', PR_avg_num);

fprintf('Inductor:   p_L(t) = -%.2f*sin(1256 t) W (avg = 0)\n', PL_amp_theory);
fprintf('  Average power (numeric)  = %.2f W\n\n', PL_avg_num);

fprintf('Capacitor:  p_C(t) = +%.2f*sin(1256 t) W (avg = 0)\n', PC_amp_theory);
fprintf('  Average power (numeric)  = %.2f W\n\n', PC_avg_num);

% ---------- Plots ----------
figure('Name','Instantaneous Power','Color','w');

subplot(3,1,1);
plot(t, v, 'LineWidth', 1.2); hold on;
plot(t, iR, 'LineWidth', 1.2);
plot(t, pR, 'LineWidth', 1.2);
grid on; xlabel('Time (s)'); ylabel('R: v, i, p');
legend('v(t) [V]','i_R(t) [A]','p_R(t) [W]','Location','best');

subplot(3,1,2);
plot(t, v, 'LineWidth', 1.2); hold on;
plot(t, iL, 'LineWidth', 1.2);
plot(t, pL, 'LineWidth', 1.2);
grid on; xlabel('Time (s)'); ylabel('L: v, i, p');
legend('v(t) [V]','i_L(t) [A]','p_L(t) [W]','Location','best');

subplot(3,1,3);
plot(t, v, 'LineWidth', 1.2); hold on;
plot(t, iC, 'LineWidth', 1.2);
plot(t, pC, 'LineWidth', 1.2);
grid on; xlabel('Time (s)'); ylabel('C: v, i, p');
legend('v(t) [V]','i_C(t) [A]','p_C(t) [W]','Location','best');

% ---------- Optional: save figures ----------
% print('-dpng','-r300','power_RLC_variantC.png');
