
% Formulas from the course handout:
%   Phi(t) = B*S*cos(omega*t)
%   e(t)   = N*B*S*omega*sin(omega*t)

% --------- Variant C data ----------
N   = 100;          % turns
a   = 0.06;         % m
b   = 0.10;         % m
B   = 0.4;          % tesla
rpm = 3000;         % rev/min

% --------- Derived quantities -------
S     = a*b;                     % coil area [m^2]
omega = 2*pi*rpm/60;             % angular speed [rad/s] = 314.159
f     = rpm/60;                  % Hz (50 Hz)
T     = 1/f;                     % period [s] (0.02 s)

% --------- Time vector (two periods for plots) -----
t = linspace(0, 2*T, 2000);

% --------- Flux and EMF ----------------------------
Phi = B*S*cos(omega*t);                  % [Wb] (per turn)
Emax = N*B*S*omega;                      % peak emf [V]
e   = Emax*sin(omega*t);                 % [V]

% --------- Plots -----------------------------------
figure(1); clf
tiledlayout(2,1);

% Flux
nexttile; 
plot(t, Phi, 'LineWidth', 1.6); grid on
xlabel('t [s]'); ylabel('\Phi(t) [Wb]')
title(sprintf('Flux (per turn): \\Phi(t)=B S cos(\\omega t),  B=%.1f T, S=%.4f m^2', B, S))

% EMF
nexttile; 
plot(t, e, 'LineWidth', 1.6); grid on
xlabel('t [s]'); ylabel('e(t) [V]')
title(sprintf('EMF: e(t)=N B S \\omega sin(\\omega t),  E_{max}=%.1f V, f=%.0f Hz', Emax, f))

% --------- Save figure ------------------------------
outdir = 'Week1/Exercise1/figures';
if ~exist(outdir,'dir'); mkdir(outdir); end
saveas(gcf, fullfile(outdir,'coil_flux_emf.png'));

% --------- Requested sample values ------------------
ts = [0.001 0.004 0.008];          % seconds
Phi_samp = B*S*cos(omega*ts);      % [Wb]
e_samp   = Emax*sin(omega*ts);     % [V]

samples = table(ts(:), Phi_samp(:), e_samp(:), ...
    'VariableNames', {'t_s','Phi_Wb','e_V'});
disp(samples)

% Save samples as CSV next to the report
tbl_path = fullfile('Week1','Exercise1','samples.csv');
if ~exist(fileparts(tbl_path),'dir'); mkdir(fileparts(tbl_path)); end
writetable(samples, tbl_path);

% --------- Quick numeric summary for the report -----
Erms = Emax/sqrt(2);
fprintf('\nSummary:\n');
fprintf('  Area S = %.4f m^2\n', S);
fprintf('  omega  = %.3f rad/s,  f = %.1f Hz,  T = %.3f s\n', omega, f, T);
fprintf('  Emax   = %.1f V,  Erms = %.1f V\n\n', Emax, Erms);
