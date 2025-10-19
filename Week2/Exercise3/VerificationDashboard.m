function VerificationDashboard
% Comprehensive Verification Dashboard for Exercise 3
% - Tables of node voltages, branch currents, and complex powers
% - KCL residual + power balance checks with green/red indicators
% - Polar diagram of complex powers (loads vs sources delivered)

clc; close all;

% === Load results (from MAT file if present, else built-in values) ===
[Node, V, Branch, Ibranch, Element, S_passive, S_sources_delivered, KCLres] = loadData();

% === 1) Window & layout ===
f = uifigure('Name','Verification Dashboard','Position',[80 80 1100 650]);
f.Color = [0.96 0.96 0.96];

g = uigridlayout(f,[4 3]);
g.RowHeight   = {40, '1x', '1x', 260};
g.ColumnWidth = {340, '1x', '1x'};

titleLabel = uilabel(g, 'Text','Comprehensive Verification Dashboard', ...
    'FontSize',16,'FontWeight','bold','HorizontalAlignment','center');
titleLabel.Layout.Row = 1;
titleLabel.Layout.Column = [1 3];

% === 2) Node voltages table ===
dataV = table(Node', abs(V).', rad2deg(angle(V)).', ...
    'VariableNames',{'Node','|V| (V)','Angle (deg)'});
tblV = uitable(g,'Data',dataV);
tblV.Layout.Row = 2; tblV.Layout.Column = 1;
tblV.ColumnWidth = {80,110,110};
tblV.FontSize = 11;
tblV.Tooltip = 'Node Voltages (phasor domain)';

% === 3) Branch currents table ===
dataI = table(Branch', abs(Ibranch).', rad2deg(angle(Ibranch)).', ...
    'VariableNames',{'Branch','|I| (A)','Angle (deg)'});
tblI = uitable(g,'Data',dataI);
tblI.Layout.Row = 2; tblI.Layout.Column = 2;
tblI.ColumnWidth = {110,110,110};
tblI.FontSize = 11;
tblI.Tooltip = 'Branch currents (phasor domain)';

% === 4) Power summary (passive elements) ===
dataP = table(Element', real(S_passive).', imag(S_passive).', ...
    'VariableNames',{'Element','P (W)','Q (var)'});
tblP = uitable(g,'Data',dataP);
tblP.Layout.Row = 2; tblP.Layout.Column = 3;
tblP.ColumnWidth = {130,120,120};
tblP.FontSize = 11;
tblP.Tooltip = 'Complex power absorbed by each passive element';

% === 5) Verification indicators ===
% Sources are provided as "delivered" values (negative of absorbed).
pwrResidual = sum(S_sources_delivered) + sum(S_passive);
pwrOK = abs(pwrResidual) < 1e-10;
kclOK = max(abs(KCLres)) < 1e-12;

pn1 = uipanel(g,'Title','KCL Verification','FontWeight','bold','FontSize',12); 
pn1.Layout.Row=3; pn1.Layout.Column=1;
uilabel(pn1,'Text',sprintf('max |KCL residual| = %.2e',max(abs(KCLres))), ...
    'FontColor', ternary(kclOK,[0 0.5 0],[0.85 0 0]), 'FontSize',12);

pn2 = uipanel(g,'Title','Power Balance','FontWeight','bold','FontSize',12);
pn2.Layout.Row=3; pn2.Layout.Column=2;
uilabel(pn2,'Text',sprintf('sum(S_{sources}) + sum(S_{passive}) = %.2e + j%.2e', ...
    real(pwrResidual), imag(pwrResidual)), ...
    'FontColor', ternary(pwrOK,[0 0.5 0],[0.85 0 0]), 'FontSize',12);

pn3 = uipanel(g,'Title','Overall Status','FontWeight','bold','FontSize',12);
pn3.Layout.Row=3; pn3.Layout.Column=3;
uilabel(pn3,'Text', ternary(kclOK && pwrOK, ...
    '✅ All verification checks passed', '⚠️ Check residuals/inputs'), ...
    'FontSize',14,'FontWeight','bold', ...
    'FontColor', ternary(kclOK && pwrOK,[0 0.5 0],[0.85 0 0]));

% === 6) Polar phasor power diagram ===
pnPlot = uipanel(g, 'Title', 'Complex Power Distribution', ...
    'FontWeight', 'bold', 'FontSize', 12);
pnPlot.Layout.Row = 4;
pnPlot.Layout.Column = [1 3];

ax = polaraxes(pnPlot);                     % <- true polaraxes (not uiaxes)
hold(ax, 'on');
polarplot(ax, angle(S_passive), abs(S_passive), 'o-','LineWidth',2, 'DisplayName','Loads (absorbed)');
polarplot(ax, angle(S_sources_delivered), abs(S_sources_delivered), 'x--','LineWidth',1.5, 'DisplayName','Sources (delivered)');
ax.ThetaZeroLocation = 'top';
ax.ThetaDir          = 'clockwise';
title(ax, 'Complex Power (Loads vs Sources)');
legend(ax, 'Location', 'bestoutside');

end % ===== end main =====


% ---------- local helpers ----------

function c = ternary(cond, a, b)
% simple inline ternary (works for strings or RGB vectors)
if cond, c = a; else, c = b; end
end

function [Node, V, Branch, Ibranch, Element, S_passive, S_sources_delivered, KCLres] = loadData()
% Attempts to load results saved by ex3_week2.m; if not found, uses
% the verified values you posted in screenshots.

if exist('ex3_results.mat','file')
    S = load('ex3_results.mat');
    Node   = S.Node;
    V      = S.V;
    Branch = S.Branch;
    Ibranch= S.Ibranch;
    Element= S.Element;
    S_passive = S.S_passive;                 % absorbed by loads
    S_sources_delivered = S.S_sources_delivered; % delivered by sources
    KCLres = S.KCLres;
    return
end

% ---- Fallback: hard-coded verified values ----
Node = {'N2','N3','N4','N_Delta','N6'};

V = [ ...
    13.9638*exp(1j*deg2rad(-15.8830)), ...  % V2
    17.9540*exp(1j*deg2rad(  4.0945)), ...  % V3
    18.2368*exp(1j*deg2rad( 27.3418)), ...  % V4
    20.5668*exp(1j*deg2rad(  4.8924)), ...  % VΔ
    14.8982*exp(1j*deg2rad( 38.5996))  ...  % V6
    ];

Branch  = {'I2Delta','I4Delta','I3Delta','I23','I2top','I36','I6g'};
Ibranch = [ ...
    1.4402*exp(1j*deg2rad(-90.3652)), ...
    1.6844*exp(1j*deg2rad( 84.2921)), ...
    0.2840*exp(1j*deg2rad(-123.8822)), ...
    3.4678*exp(1j*deg2rad(140.5279)), ...
    2.7928*exp(1j*deg2rad(-15.8838)), ...
    0.4966*exp(1j*deg2rad(-51.4004)), ...
    0.4966*exp(1j*deg2rad(-51.4004))  ...
    ];

Element = {'5 ohm','2j ohm','Za','Zb','Zc','20 ohm','j30 ohm','Yno shunt'};

S_passive = [ ...
    (38.997 + 1j*0.000), ...
    ( 0.000 + 1j*24.052), ...
    ( 8.095 - 1j*10.119), ...
    (10.380 + 1j* 8.304), ...
    ( 0.472 - 1j* 0.590), ...
    ( 4.932 + 1j* 0.000), ...
    (-0.000 + 1j* 7.399), ...
    ( 0.000 - 1j* 6.652) ...
    ];

% Sources *delivered* to the network (negative of absorbed)
S_sources_delivered = [ ...
    -(46.124 + 1j*54.792), ...  % right current source
    -(16.752 - 1j*32.399)  ...  % left Norton current
    ];

% KCL residuals from the solver run (≈ machine precision)
KCLres = [ -4.44e-16, 0, -4.44e-16, 2.22e-16, -3.33e-16 ];
end
