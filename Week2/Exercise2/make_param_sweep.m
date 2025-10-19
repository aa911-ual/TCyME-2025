%% Parametric sweep animations for Week 2 Exercise 2  Variant C
clear; clc; close all;

% Circuit data
Vs_mag = 80;                 % RMS magnitude
Vs_ang = -45;                % degrees
Vs = Vs_mag*exp(1j*deg2rad(Vs_ang));

L1 = 50e-3;  R1 = 150;
C  = 20e-6;  L2 = 80e-3;  R2 = 100;

% Function handle for Zin(f)
Zin_of_f = @(f) 1j*2*pi*f*L1 + ...
    ( R1.*( 1./(1j*2*pi*f*C) + R2 + 1j*2*pi*f*L2 ) ) ./ ...
    ( R1 + 1./(1j*2*pi*f*C) + R2 + 1j*2*pi*f*L2 );

% Sweep settings
fmin = 50; fmax = 200; nsteps = 180;           % frames
fspan = linspace(fmin, fmax, nsteps);

% Precompute Zin and Is for axis scaling
Zs = arrayfun(Zin_of_f, fspan);
Is = Vs ./ Zs;

%% Animation 1: complex-plane trajectory of Zin(f)
gif1 = 'zin_trajectory.gif';

xmin = min(real(Zs)); xmax = max(real(Zs));
ymin = min(imag(Zs)); ymax = max(imag(Zs));
dx = xmax - xmin; dy = ymax - ymin; pad = 0.08;
ax = [xmin-dx*pad, xmax+dx*pad, ymin-dy*pad, ymax+dy*pad];

figure('Color','w');
for k = 1:nsteps
    plot(real(Zs(1:k)), imag(Zs(1:k)), 'LineWidth', 1.6); hold on
    plot(real(Zs(k)), imag(Zs(k)), 'ko','MarkerFaceColor','k'); hold off
    axis(ax); axis equal; grid on
    xlabel('Re\{Z_{in}\} [\Omega]'); ylabel('Im\{Z_{in}\} [\Omega]');
    title(sprintf('Z_{in}(f)    f = %.1f Hz', fspan(k)));
    drawnow
    frame = getframe(gcf);
    [A,map] = rgb2ind(frame2im(frame),256);
    if k==1
        imwrite(A,map,gif1,'gif','LoopCount',Inf,'DelayTime',0.05);
    else
        imwrite(A,map,gif1,'gif','WriteMode','append','DelayTime',0.05);
    end
end
disp(['Saved  ', gif1]);

%% Animation 2: time-domain waveforms while frequency varies
gif2 = 'waveform_sweep.gif';

% Time window large enough for low frequency. We rescale x-limits per frame.
t = linspace(0, 0.06, 2000);  % seconds

figure('Color','w');
for k = 1:nsteps
    f = fspan(k);  w = 2*pi*f;
    Zin = Zs(k);   I  = Is(k);

    vs = sqrt(2)*abs(Vs)*cos(w*t + angle(Vs));
    is = sqrt(2)*abs(I )*cos(w*t + angle(I ));

    clf
    plot(t*1000, vs, 'LineWidth',1.3); hold on
    plot(t*1000, is, 'LineWidth',1.3);
    grid on
    xlabel('Time [ms]'); ylabel('Amplitude');
    pf = cosd( rad2deg(angle(I)) - Vs_ang );
    title(sprintf('v_s(t) and i_s(t)    f = %.1f Hz    pf = %.3f', f, pf));
    % show about two periods
    xlim([0, 1000*(2/f)]);
    ylim([-max(Vs_mag*sqrt(2))*1.2, max(Vs_mag*sqrt(2))*1.2]);
    legend('v_s(t)','i_s(t)','Location','southoutside');
    drawnow

    frame = getframe(gcf);
    [A,map] = rgb2ind(frame2im(frame),256);
    if k==1
        imwrite(A,map,gif2,'gif','LoopCount',Inf,'DelayTime',0.06);
    else
        imwrite(A,map,gif2,'gif','WriteMode','append','DelayTime',0.06);
    end
end
disp(['Saved  ', gif2]);

