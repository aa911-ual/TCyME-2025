% Interactive flux and emf visualization with adjustable rpm
% Variant C constants
N = 100;
a = 0.06; b = 0.10;   % m
B = 0.4;              % Tesla
S = a*b;              % m^2
t = linspace(0,0.04,2000);  % 40 ms (2 cycles at 50 Hz)

% Create UI figure
f = uifigure('Name','Flux and EMF Interactive','Position',[100 100 800 600]);

% Create axes
ax1 = uiaxes(f,'Position',[50 320 700 230]);
ax2 = uiaxes(f,'Position',[50 60 700 230]);

% Initial rpm
rpm0 = 3000;
omega0 = 2*pi*rpm0/60;
phi = B*S*cos(omega0*t);
emf = N*B*S*omega0*sin(omega0*t);

% Plot initial curves
fluxLine = plot(ax1,t,phi,'b','LineWidth',1.5);
title(ax1,'Flux \Phi(t)'); xlabel(ax1,'Time (s)'); ylabel(ax1,'\Phi (Wb)');

emfLine = plot(ax2,t,emf,'r','LineWidth',1.5);
title(ax2,'Induced EMF e(t)'); xlabel(ax2,'Time (s)'); ylabel(ax2,'e (V)');

% Slider for rpm
sld = uislider(f,...
    'Position',[100 10 600 3],...
    'Limits',[1000 6000],...
    'Value',rpm0,...
    'MajorTicks',1000:1000:6000,...
    'ValueChangedFcn',@(sld,event) updatePlot(sld,ax1,ax2,t,N,B,S,fluxLine,emfLine));

% Function to update plots
function updatePlot(sld,ax1,ax2,t,N,B,S,fluxLine,emfLine)
    rpm = sld.Value;
    omega = 2*pi*rpm/60;
    phi = B*S*cos(omega*t);
    emf = N*B*S*omega*sin(omega*t);
    fluxLine.YData = phi;
    emfLine.YData = emf;
    title(ax1,sprintf('Flux \\Phi(t) at %d rpm',round(rpm)));
    title(ax2,sprintf('Induced EMF e(t) at %d rpm',round(rpm)));
end
