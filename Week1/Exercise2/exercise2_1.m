% exercise2_1.m  -- Variant C currents for R, L, C
% Source: v(t) = Vm*sin(omega*t)

Vm    = 80;      % volts (peak)
omega = 628;     % rad/s  (~100 Hz)

% Element values from the assignment (use plain ASCII):
R = 40;          % ohms
L = 0.1;         % henry
C = 50e-6;       % farad  (50 microfarads = 50 x 10^-6 F)

% Reactances at this omega
XL = omega*L;        % inductive reactance
XC = 1/(omega*C);    % capacitive reactance

% Peak currents from the time-domain formulas
IR_peak = Vm/R;          % iR(t) amplitude
IL_peak = Vm/XL;         % iL(t) amplitude (lags 90 deg)
IC_peak = Vm/XC;         % iC(t) amplitude (leads 90 deg)

% RMS currents
IR_rms = IR_peak/sqrt(2);
IL_rms = IL_peak/sqrt(2);
IC_rms = IC_peak/sqrt(2);

% Print results
fprintf('Resistor:  I_peak = %.3f A,  I_rms = %.3f A,  phase = 0 deg (in phase)\n', IR_peak, IR_rms);
fprintf('Inductor:  I_peak = %.3f A,  I_rms = %.3f A,  phase = -90 deg (lags)\n',    IL_peak, IL_rms);
fprintf('Capacitor: I_peak = %.3f A,  I_rms = %.3f A,  phase = +90 deg (leads)\n',  IC_peak, IC_rms);
