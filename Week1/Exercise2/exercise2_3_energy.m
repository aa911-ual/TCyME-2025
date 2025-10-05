% exercise2_3_energy.m  -- Energy flow: consumption vs storage (Variant C)

% --------- Given source (Variant C) ----------
Vm    = 80;            % V (peak)
omega = 628;           % rad/s  (~100 Hz)
f     = omega/(2*pi);  % Hz
T     = 1/f;           % period (s)

% --------- Element values ----------
R = 40;          % ohm
L = 0.1;         % H
C = 50e-6;       % F   (50 microfarads = 50 x 10^-6 F)

% --------- Current amplitudes from Section 2.1 ----------
IR_peak = Vm/R;                % 2.000 A (in phase)
IL_peak = Vm/(omega*L);        % 1.274 A (lags 90 deg)
IC_peak = Vm*(omega*C);        % 2.512 A (leads 90 deg)

% Phase shifts (rad): R=0, L=-pi/2, C=+pi/2
phi_R = 0;
phi_L = -pi/2;
phi_C = +pi/2;

% --------- Time base (two periods to make trends clear) ----------
N = 4000;
t = linspace(0, 2*T, N);

% --------- Voltage and currents ----------
v  = Vm * sin(omega*t);
iR = IR_peak * sin(omega*t + phi_R);
iL = IL_peak * sin(omega*t + phi_L);
iC = IC_peak * sin(omega*t + phi_C);

% --------- Instantaneous power p(t) = v(t) * i(t) ----------
pR = v .* iR;
pL = v .* iL;
pC = v .* iC;

% --------- Energies ----------
% Resistor: energy "consumed" (dissipated) is the time integral of power
% Use cumulative trapezoidal integration starting at 0 (J).
wR = cumtrapz(t, pR);

% Inductor: stored magnetic energy wL = (1/2) * L * i^2(t)
wL = 0.5 * L * (iL.^2);

% Capacitor: stored electric energy wC = (1/2) * C * v^2(t)
wC = 0.5 * C * (v.^2);

% --------- Reference (theoretical) values ----------
PR_avg   = (Vm^2)/(2*R);       % 80.00 W
W_R_oneT = PR_avg * T;         % 0.80 J per period

wL_max_theory = 0.5 * L * (IL_peak^2);              % 0.0812 J
wC_max_theory = 0.5 * C * (Vm^2);                   % 0.1600 J

% Numerical maxima from the waveforms
wL_max_num = max(wL);
wC_max_num = max(wC);

% --------- Averages of power over one period (last period) ----------
idx = t >= T & t <= 2*T;
PR_avg_num = mean(pR(idx));    % ~80 W
PL_avg_num = mean(pL(idx));    % ~0 W
PC_avg_num = mean(pC(idx));    % ~0 W

% --------- Report to Command Window ----------
fprintf('--- Energy Flow (Variant C) ---\n');
fprintf('Resistor:\n');
fprintf('  Average power = %.2f W (theory), %.2f W (numeric)\n', PR_avg, PR_avg_num);
fprintf('  Energy dissipated per period = %.2f J\n\n', W_R_oneT);

fprintf('Inductor:\n');
fprintf('  wL_max (theory) = %.4f J,  wL_max (numeric) = %.4f J\n', wL_max_theory, wL_max_num);
fprintf('  Average power over a period (numeric) = %.2f W\n\n', PL_avg_num);

fprintf('Capacitor:\n');
fprintf('  wC_max (theory) = %.4f J,  wC_max (numeric) = %.4f J\n', wC_max_theory, wC_max_num);
fprintf('  Average power over a period (numeric) = %.2f W\n\n', PC_avg_num);

% --------- Plots (energy vs time) ----------
figure('Name','Energy Flow','Color','w');

subplot(3,1,1);
plot(t, wR, 'LineWidth', 1.2);
grid on; xlabel('Time (s)'); ylabel('w_R(t) [J]');
title('Resistor: cumulative energy dissipated');
% Note: w_R(t) increases on average because p_R(t) >= 0.

subplot(3,1,2);
plot(t, wL, 'LineWidth', 1.2);
grid on; xlabel('Time (s)'); ylabel('w_L(t) [J]');
title('Inductor: stored magnetic energy = 0.5 L i^2(t)');

subplot(3,1,3);
plot(t, wC, 'LineWidth', 1.2);
grid on; xlabel('Time (s)'); ylabel('w_C(t) [J]');
title('Capacitor: stored electric energy = 0.5 C v^2(t)');

% --------- Optional: save figure for the report ----------
% print('-dpng','-r300','Energy Flow.png');   % or 'Energy_Flow.png'
