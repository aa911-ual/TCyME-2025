% Week 3 - Exercise 2 - Variant C
clear; clc;

% Sources
E1 = 120*exp(1j*deg2rad(45));      % V
I1 = 6*exp(1j*deg2rad(-60));       % A

% Impedances
Z1 = 10; 
Z2 = 8+6j;
Z3 = 15j;
Z4 = 12-4j;
Z5 = 10;
ZL = 8+6j;

% Admittances
Y1 = 1/Z1; Y2 = 1/Z2; Y3 = 1/Z3; Y4 = 1/Z4; Y5 = 1/Z5;

% Unknowns: V1, V2, VA  (open circuit at B)
A = [ (Y1+Y3+Y2)   -Y3           0 ;
      -Y3          (Y3+Y5+Y4)   -Y5;
       0           -Y5           Y5 ];
b = [ Y1*E1; 0; I1 ];

V = A\b; V1 = V(1); V2 = V(2); VA = V(3);
Eth = VA;                              % Thévenin voltage

% Zth with sources deactivated
Z12 = (Z1*Z2)/(Z1+Z2);
Zb  = Z3 + Z12;
Zeq2 = (Z4*Zb)/(Z4+Zb);
Zth = Z5 + Zeq2;

% Norton
In = Eth / Zth;

% Load results using Thévenin
IL = Eth / (Zth + ZL);
VL = ZL * IL;
PL = real(VL*conj(IL));
QL = imag(VL*conj(IL));

% Optimum load and maximum power
ZL_opt = conj(Zth);
Pmax = abs(Eth)^2 / (4*real(Zth));

% Print
toPolar = @(z) [abs(z) rad2deg(angle(z))];
fprintf('Node voltages (open circuit)\n');
fprintf('V1  = %9.4f  angle %9.4f deg  V\n', toPolar(V1));
fprintf('V2  = %9.4f  angle %9.4f deg  V\n', toPolar(V2));
fprintf('VA  = %9.4f  angle %9.4f deg  V  (Eth)\n', toPolar(Eth));

fprintf('\nThevenin\n');
fprintf('Zth = %9.4f + j%9.4f  ohm  (mag %7.4f, ang %7.4f deg)\n', real(Zth), imag(Zth), toPolar(Zth));
fprintf('Eth = %9.4f  angle %9.4f deg  V\n', toPolar(Eth));

fprintf('\nNorton\n');
fprintf('In  = %9.4f  angle %9.4f deg  A\n', toPolar(In));

fprintf('\nLoad ZL results\n');
fprintf('IL  = %9.4f  angle %9.4f deg  A\n', toPolar(IL));
fprintf('VL  = %9.4f  angle %9.4f deg  V\n', toPolar(VL));
fprintf('PL  = %9.4f  W,   QL = %9.4f  var\n', PL, QL);

fprintf('\nMax power transfer\n');
fprintf('ZL_opt = %9.4f + j%9.4f  ohm\n', real(ZL_opt), imag(ZL_opt));
fprintf('Pmax   = %9.4f  W\n', Pmax);

% Optional visualization: power vs real part of ZL with imag set to -imag(Zth)
Rrange = linspace(0.1, 60, 400);
Xopt = -imag(Zth);
Pcurve = zeros(size(Rrange));
for k=1:numel(Rrange)
    Ztest = Rrange(k) + 1j*Xopt;
    ILk = Eth / (Zth + Ztest);
    VLk = Ztest * ILk;
    Pcurve(k) = real(VLk * conj(ILk));
end
figure; plot(Rrange, Pcurve, 'LineWidth',1.4);
xlabel('R_L [ohm] with X_L = -Im(Z_{Th})'); ylabel('P_{load} [W]');
title('Load power versus R_L at conjugate reactive match');
grid on;
