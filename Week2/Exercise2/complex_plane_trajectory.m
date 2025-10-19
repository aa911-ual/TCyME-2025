%% Complex Plane Impedance Trajectory for Week 2 Exercise 2
clear; clc; close all;

% Circuit parameters
L1 = 50e-3; R1 = 150;
C  = 20e-6; L2 = 80e-3; R2 = 100;
Vs = 80*exp(1j*deg2rad(-45));   % source phasor
f = linspace(50,200,300);       % frequency sweep

% Impedance function
Zin = @(f) 1j*2*pi*f*L1 + ...
    ( R1.*( 1./(1j*2*pi*f*C) + R2 + 1j*2*pi*f*L2 ) ) ./ ...
    ( R1 + 1./(1j*2*pi*f*C) + R2 + 1j*2*pi*f*L2 );

Zf = arrayfun(Zin,f);

% Plot the full trajectory
figure('Color','w');
plot(real(Zf), imag(Zf), 'b-', 'LineWidth', 1.6); hold on;
plot(real(Zf(1)), imag(Zf(1)), 'ko', 'MarkerFaceColor', 'g'); % start point (50 Hz)
plot(real(Zf(end)), imag(Zf(end)), 'ko', 'MarkerFaceColor', 'r'); % end point (200 Hz)
xlabel('Re\{Z_{in}\} [\Omega]');
ylabel('Im\{Z_{in}\} [\Omega]');
title('Complex-plane trajectory of input impedance Z_{in}(f)');
legend('Trajectory 50–200 Hz','Start (50 Hz)','End (200 Hz)','Location','best');
grid on; axis equal;

exportgraphics(gcf,'complex_plane_static.png','Resolution',300);

%% Create animated GIF
gifname = 'complex_plane_trajectory.gif';
for k = 1:length(f)
    plot(real(Zf(1:k)), imag(Zf(1:k)), 'b-', 'LineWidth', 1.6); hold on;
    plot(real(Zf(k)), imag(Zf(k)), 'ko', 'MarkerFaceColor','k'); hold off;
    xlabel('Re\{Z_{in}\} [\Omega]');
    ylabel('Im\{Z_{in}\} [\Omega]');
    title(sprintf('Z_{in}(f) trajectory - f = %.1f Hz', f(k)));
    grid on; axis equal;
    axis([min(real(Zf))-10 max(real(Zf))+10 min(imag(Zf))-10 max(imag(Zf))+10]);
    drawnow
    frame = getframe(gcf);
    [A,map] = rgb2ind(frame2im(frame),256);
    if k==1
        imwrite(A,map,gifname,'gif','LoopCount',Inf,'DelayTime',0.05);
    else
        imwrite(A,map,gifname,'gif','WriteMode','append','DelayTime',0.05);
    end
end
disp('Saved complex_plane_trajectory.gif');
