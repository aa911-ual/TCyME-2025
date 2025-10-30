% Week 3 - Exercise 1 - Variant C
clear; clc;

% Given phasors
E1 = 150*exp(1j*deg2rad(0));       % V
E2 = 100*exp(1j*deg2rad(120));     % V

Z1 = 15 + 10j;                     % Ohm
Z2 = 20 + 0j;
Z3 = 0 + 8j;
Z4 = 12 - 6j;
Z5 = 10 + 0j;

% Mesh results
Ia = (E1 - E2) / (Z1 + Z5);
Ib =  E2 / (Z2 + Z3 + Z4);         % equals branch current through Z2
IZ2_mesh = Ib;
UZ2 = Z2*IZ2_mesh;

% Superposition contributions
IZ2_E1 = 0;                        % E2 shorted -> zero applied voltage on right ring
IZ2_E2 =  E2 / (Z2 + Z3 + Z4);
IZ2_super = IZ2_E1 + IZ2_E2;

% Display
toPolar = @(z) [abs(z) rad2deg(angle(z))];
fprintf('Ia  = %8.4f  angle %8.4f deg  A\n', toPolar(Ia));
fprintf('Ib  = %8.4f  angle %8.4f deg  A\n', toPolar(Ib));
fprintf('IZ2 mesh       = %8.4f  angle %8.4f deg  A\n', toPolar(IZ2_mesh));
fprintf('IZ2 superpos   = %8.4f  angle %8.4f deg  A\n', toPolar(IZ2_super));
fprintf('UZ2            = %8.4f  angle %8.4f deg  V\n', toPolar(UZ2));

% Time domain comparison
f = 50; w = 2*pi*f; T = 1/f;
t = linspace(0, 2*T, 2000);
i_mesh = sqrt(2)*abs(IZ2_mesh)*cos(w*t + angle(IZ2_mesh));     % assume given RMS phasors
i_super = sqrt(2)*abs(IZ2_super)*cos(w*t + angle(IZ2_super));

figure;
plot(t, i_mesh, 'LineWidth', 1.4); hold on;
plot(t, i_super, 'LineWidth', 1.2, 'LineStyle','--');
xlabel('t [s]'); ylabel('i_{Z2}(t) [A]');
title('Comparison of current through Z_2');
legend('Mesh method','Superposition','Location','best');
grid on;
