% make_frequency_sweep.m
% Frequency sweep animation (50–200 Hz)

clear; close all; clc

% Parameters
Vmax = 200;              % amplitude (V)
f_start = 50;            % start frequency (Hz)
f_end = 200;             % end frequency (Hz)
f_step = 5;              % frequency increment (Hz)
t = linspace(0, 0.04, 400);  % time vector (0–40 ms)

% Prepare figure
fig = figure('Color','k','Position',[100 100 600 400]);
axis([0 max(t)*1000 -220 220])
xlabel('Time (ms)','Color','w')
ylabel('Voltage (V)','Color','w')
title('Frequency Sweep: 50–200 Hz','Color','w')
grid on
ax = gca;
ax.XColor = 'w'; ax.YColor = 'w';

% Prepare GIF
filename = 'frequency_sweep.gif';

for f = f_start:f_step:f_end
    v = Vmax * sin(2*pi*f*t);
    plot(t*1000, v, 'm', 'LineWidth', 2);
    title(sprintf('Frequency = %d Hz', f), 'Color', 'w');
    grid on
    drawnow;
    
    % Capture frame
    frame = getframe(fig);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
    
    if f == f_start
        imwrite(A,map,filename,'gif','LoopCount',inf,'DelayTime',0.1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end

disp('✅ Frequency sweep GIF saved as frequency_sweep.gif');
