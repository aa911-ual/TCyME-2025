%% Exercise 3 - Network Analysis with Phasors
% Reference: cosine. Angles in degrees. Use j for sqrt(-1).

clear; clc;

deg = @(x) x*180/pi;                  % radians to degrees
rad = @(x) x*pi/180;                  % degrees to radians
mag = @(z) abs(z);
ang = @(z) deg(angle(z));

fprintf('=== Week 2 - Exercise 3 ===\n\n');

%% 1) Problem data
% Inner delta impedances between outer vertices a(N2), b(N4), c(N3)
Zab = 10;           % ohm
Zbc = 15;           % ohm
Zca = -1j*20;       % ohm

% Outer impedances
Ztop  = 5;          % N2 to top-left frame
Z23   = 1j*2;       % N2 to N3
Z36   = 20;         % N3 to N6
Z6g   = 1j*30;      % N6 to ground

% Sources
V5  = 75*exp(1j*rad(120));   % V at node N5 to ground (known node)
Is  = 4*exp(1j*rad(-45));    % A injected into node N3 (right current source)

% Left branch: series Vth then Zth to ground at node N4
Vth = 100*exp(1j*rad(0));    % V
Zth = -1j*50;                % ohm
% Use Norton for nodal KCL convenience
Ino = Vth/Zth;               % A
Yno = 1/Zth;                 % S

%% 2) Delta-to-wye conversion for inner triangle (N2, N4, N3)
Zsum = Zab + Zbc + Zca;
Za = Zab*Zca / Zsum;     % leg from N2 to NΔ
Zb = Zab*Zbc / Zsum;     % leg from N4 to NΔ
Zc = Zbc*Zca / Zsum;     % leg from N3 to NΔ

fprintf('Wye legs:\n');
fprintf('Za = %.6f %+.6fj ohm\n', real(Za), imag(Za));
fprintf('Zb = %.6f %+.6fj ohm\n', real(Zb), imag(Zb));
fprintf('Zc = %.6f %+.6fj ohm\n\n', real(Zc), imag(Zc));

%% 3) Admittances
Ya = 1/Za;
Yb = 1/Zb;
Yc = 1/Zc;

Ytop = 1/Ztop;
Y23  = 1/Z23;
Y36  = 1/Z36;
Y6g  = 1/Z6g;

fprintf('Admittances:\n');
fprintf('Ya  = %.6f %+.6fj S\n', real(Ya), imag(Ya));
fprintf('Yb  = %.6f %+.6fj S\n', real(Yb), imag(Yb));
fprintf('Yc  = %.6f %+.6fj S\n', real(Yc), imag(Yc));
fprintf('Y23 = %.6f %+.6fj S\n', real(Y23), imag(Y23));
fprintf('Ytop= %.6f %+.6fj S\n', real(Ytop), imag(Ytop));
fprintf('Y36 = %.6f %+.6fj S\n', real(Y36), imag(Y36));
fprintf('Y6g = %.6f %+.6fj S\n', real(Y6g), imag(Y6g));
fprintf('Yno = %.6f %+.6fj S\n\n', real(Yno), imag(Yno));

%% 4) Unknown node voltages: V2, V3, V4, Vd, V6  (V5 is known)
% KCL equations: Y*V = I
Y = zeros(5,5); I = zeros(5,1);

% Node N2
Y(1,1) = Ya + Y23 + Ytop;
Y(1,2) = -Y23;
Y(1,4) = -Ya;
I(1)   = 0;

% Node N3
Y(2,1) = -Y23;
Y(2,2) = Yc + Y23 + Y36;
Y(2,4) = -Yc;
Y(2,5) = -Y36;
I(2)   = Is;

% Node N4
Y(3,3) = Yb + Yno;
Y(3,4) = -Yb;
I(3)   = Ino;

% Node NΔ
Y(4,1) = -Ya;
Y(4,2) = -Yc;
Y(4,3) = -Yb;
Y(4,4) = Ya + Yb + Yc;
I(4)   = 0;

% Node N6
Y(5,2) = -Y36;
Y(5,5) = Y36 + Y6g;
I(5)   = 0;

% Solve
V = Y\I;
V2 = V(1); V3 = V(2); V4 = V(3); Vd = V(4); V6 = V(5);

fprintf('Node voltages (phasors):\n');
fprintf('V2 = %8.4f %+.4fj  = %8.4f ∠ %7.4f deg\n', real(V2), imag(V2), mag(V2), ang(V2));
fprintf('V3 = %8.4f %+.4fj  = %8.4f ∠ %7.4f deg\n', real(V3), imag(V3), mag(V3), ang(V3));
fprintf('V4 = %8.4f %+.4fj  = %8.4f ∠ %7.4f deg\n', real(V4), imag(V4), mag(V4), ang(V4));
fprintf('VΔ = %8.4f %+.4fj  = %8.4f ∠ %7.4f deg\n', real(Vd), imag(Vd), mag(Vd), ang(Vd));
fprintf('V6 = %8.4f %+.4fj  = %8.4f ∠ %7.4f deg\n\n', real(V6), imag(V6), mag(V6), ang(V6));
fprintf('V5 (known) = %8.4f ∠ %7.4f deg\n\n', mag(V5), ang(V5));

%% 5) Branch currents (direction: first node to second node)
I2d   = (V2 - Vd)/Za;             % N2 to NΔ through Za
I4d   = (V4 - Vd)/Zb;             % N4 to NΔ through Zb
I3d   = (V3 - Vd)/Zc;             % N3 to NΔ through Zc
I23   = (V2 - V3)/Z23;            % N2 to N3 through 2j
I2top = V2/Ztop;                  % N2 to top-left
I36   = (V3 - V6)/Z36;            % N3 to N6 through 20
I6g   = V6/Z6g;                   % N6 to ground through j30
Inosh = Yno*V4;                   % Shunt Norton current to ground at N4

fprintf('Branch currents (phasors):\n');
fprintf('I2Δ   = %8.4f ∠ %7.4f deg A\n', mag(I2d), ang(I2d));
fprintf('I4Δ   = %8.4f ∠ %7.4f deg A\n', mag(I4d), ang(I4d));
fprintf('I3Δ   = %8.4f ∠ %7.4f deg A\n', mag(I3d), ang(I3d));
fprintf('I23   = %8.4f ∠ %7.4f deg A\n', mag(I23), ang(I23));
fprintf('I2top = %8.4f ∠ %7.4f deg A\n', mag(I2top), ang(I2top));
fprintf('I36   = %8.4f ∠ %7.4f deg A\n', mag(I36), ang(I36));
fprintf('I6g   = %8.4f ∠ %7.4f deg A\n', mag(I6g), ang(I6g));
fprintf('I_Norton_shunt = %8.4f ∠ %7.4f deg A\n\n', mag(Inosh), ang(Inosh));

%% 6) KCL residuals at nodes (should be ~0 + j0)
res2 = (Ya+Y23+Ytop)*V2 - Y23*V3 - Ya*Vd - 0;
res3 = (Yc+Y23+Y36)*V3 - Y23*V2 - Yc*Vd - Y36*V6 - Is;
res4 = (Yb+Yno)*V4 - Yb*Vd - Ino;
resd = (Ya+Yb+Yc)*Vd - Ya*V2 - Yb*V4 - Yc*V3;
res6 = (Y36+Y6g)*V6 - Y36*V3 - 0;

fprintf('KCL residuals (should be near zero):\n');
fprintf('Node 2: % .3e %+.3ej\n', real(res2), imag(res2));
fprintf('Node 3: % .3e %+.3ej\n', real(res3), imag(res3));
fprintf('Node 4: % .3e %+.3ej\n', real(res4), imag(res4));
fprintf('Node Δ: % .3e %+.3ej\n', real(resd), imag(resd));
fprintf('Node 6: % .3e %+.3ej\n\n', real(res6), imag(res6));

%% 7) Complex powers for impedances and sources
% Passive elements
S_5   = V2 * conj(I2top);
S_2j  = (V2 - V3) * conj(I23);
S_Za  = (V2 - Vd) * conj(I2d);
S_Zb  = (V4 - Vd) * conj(I4d);
S_Zc  = (V3 - Vd) * conj(I3d);
S_20  = (V3 - V6) * conj(I36);
S_j30 = V6 * conj(I6g);
S_Yno = V4 * conj(Inosh);

% Sources: absorbed power taken positive
S_Is   = V3 * conj(Is);    % right current source
S_Ino  = V4 * conj(Ino);   % Norton current source at N4
S_V5   = 0;                % isolated from this reduced network

Spassive = S_5 + S_2j + S_Za + S_Zb + S_Zc + S_20 + S_j30 + S_Yno;
Ssources = S_Is + S_Ino + S_V5;

fprintf('Complex powers (P + jQ):\n');
fprintf('5 ohm:          P = %9.3f W,  Q = %9.3f var\n', real(S_5),  imag(S_5));
fprintf('2j ohm:         P = %9.3f W,  Q = %9.3f var\n', real(S_2j), imag(S_2j));
fprintf('Za (N2-NΔ):     P = %9.3f W,  Q = %9.3f var\n', real(S_Za), imag(S_Za));
fprintf('Zb (N4-NΔ):     P = %9.3f W,  Q = %9.3f var\n', real(S_Zb), imag(S_Zb));
fprintf('Zc (N3-NΔ):     P = %9.3f W,  Q = %9.3f var\n', real(S_Zc), imag(S_Zc));
fprintf('20 ohm:         P = %9.3f W,  Q = %9.3f var\n', real(S_20), imag(S_20));
fprintf('j30 ohm:        P = %9.3f W,  Q = %9.3f var\n', real(S_j30),imag(S_j30));
fprintf('Yno shunt:      P = %9.3f W,  Q = %9.3f var\n', real(S_Yno),imag(S_Yno));
fprintf('Total passive:  P = %9.3f W,  Q = %9.3f var\n\n', real(Spassive), imag(Spassive));

fprintf('Sources absorbed:\n');
fprintf('Right current:  P = %9.3f W,  Q = %9.3f var\n', real(S_Is),  imag(S_Is));
fprintf('Left Norton:    P = %9.3f W,  Q = %9.3f var\n', real(S_Ino), imag(S_Ino));
fprintf('V at N5:        P = %9.3f W,  Q = %9.3f var\n', real(S_V5),  imag(S_V5));
fprintf('Total sources:  P = %9.3f W,  Q = %9.3f var\n\n', real(Ssources), imag(Ssources));

% Power balance check: Spassive + Sdelivered = 0
balance = Spassive + (-Ssources); % delivered by sources is negative absorbed
fprintf('Power balance Spassive + Ssources(delivered) = % .3e %+.3ej\n', real(balance), imag(balance));
