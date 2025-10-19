function DeltaWyeCalculator
% Delta Wye conversion calculator with visualization
% Works for complex impedances

%% UI
f = uifigure('Name','Delta Wye Calculator','Position',[100 100 1100 620]);

gl = uigridlayout(f,[6 6]);
gl.RowHeight  = {35 35 35 35 35 '1x'};
gl.ColumnWidth = {150 150 150 150 150 '1x'};

uilabel(gl,'Text','Delta Z_ab','FontWeight','bold');
uilabel(gl,'Text','Delta Z_bc','FontWeight','bold');
uilabel(gl,'Text','Delta Z_ca','FontWeight','bold');

% Real and imag inputs for each delta branch
[zabR,zabI] = complexInputs(gl,'Z_ab',  2,1);
[zbcR,zbcI] = complexInputs(gl,'Z_bc',  3,1);
[zcaR,zcaI] = complexInputs(gl,'Z_ca',  4,1);

% Default values from your exercise
zabR.Value = 10;    zabI.Value = 0;
zbcR.Value = 15;    zbcI.Value = 0;
zcaR.Value = 0;     zcaI.Value = -20;

btn = uibutton(gl,'Text','Compute and Plot','ButtonPushedFcn',@updateAll);
btn.Layout.Row = 5; btn.Layout.Column = [1 3];

btnSave = uibutton(gl,'Text','Save PNG','ButtonPushedFcn',@savePNG);
btnSave.Layout.Row = 5; btnSave.Layout.Column = 4;

% Results table
tbl = uitable(gl,'ColumnEditable',false(1,5));
tbl.Layout.Row = [1 5]; tbl.Layout.Column = 5;
tbl.ColumnName = {'Element','Rectangular','Magnitude','Angle deg','Admittance S'};

% Axes for plot
ax = uiaxes(gl); ax.Layout.Row = [1 6]; ax.Layout.Column = 6;
axis(ax,'equal'); grid(ax,'on'); ax.Box = 'on';
title(ax,'Delta and Wye Visualization');

% Info box
txt = uitextarea(gl,'Editable','off','Value', ...
    {'Usage'
     'Enter complex values for the delta branches Z_ab, Z_bc, Z_ca'
     'Rectangular form is Re and Im in ohm'
     'Press Compute and Plot'});
txt.Layout.Row = 6; txt.Layout.Column = [1 5];

% Initial draw
updateAll();

%% Callbacks
    function updateAll(~,~)
        Zab = complex(zabR.Value, zabI.Value);
        Zbc = complex(zbcR.Value, zbcI.Value);
        Zca = complex(zcaR.Value, zcaI.Value);

        [Za,Zb,Zc] = delta2wye(Zab,Zbc,Zca);
        Ya = 1/Za; Yb = 1/Zb; Yc = 1/Zc;

        % Fill table
        data = {
            'Z_ab',  cstr(Zab), mag(Zab), angd(Zab), cstr(1/Zab);
            'Z_bc',  cstr(Zbc), mag(Zbc), angd(Zbc), cstr(1/Zbc);
            'Z_ca',  cstr(Zca), mag(Zca), angd(Zca), cstr(1/Zca);
            'Z_a',   cstr(Za),  mag(Za),  angd(Za),  cstr(Ya);
            'Z_b',   cstr(Zb),  mag(Zb),  angd(Zb),  cstr(Yb);
            'Z_c',   cstr(Zc),  mag(Zc),  angd(Zc),  cstr(Yc);
            };
        tbl.Data = data;

        % Plot
        plotDeltaWye(ax,Zab,Zbc,Zca,Za,Zb,Zc);
    end

    function savePNG(~,~)
        [file,path] = uiputfile('delta_wye.png','Save figure as');
        if isequal(file,0), return; end
        exportgraphics(ax, fullfile(path,file), 'Resolution',300);
    end
end

function [hR,hI] = complexInputs(gl,label,row,firstCol)
    % --- Real part label
    lblR = uilabel(gl);
    lblR.Text = [label, ' real'];
    lblR.HorizontalAlignment = 'right';
    lblR.Layout.Row = row;
    lblR.Layout.Column = firstCol;

    % --- Real input
    hR = uieditfield(gl,'numeric');
    hR.Layout.Row = row;
    hR.Layout.Column = firstCol + 1;

    % --- Imag part label
    lblI = uilabel(gl);
    lblI.Text = [label, ' imag'];
    lblI.HorizontalAlignment = 'right';
    lblI.Layout.Row = row;
    lblI.Layout.Column = firstCol + 2;

    % --- Imag input
    hI = uieditfield(gl,'numeric');
    hI.Layout.Row = row;
    hI.Layout.Column = firstCol + 3;
end


%% Math helpers
function [Za,Zb,Zc] = delta2wye(Zab,Zbc,Zca)
    Zsum = Zab + Zbc + Zca;
    Za = Zab*Zca / Zsum;   % node a to center
    Zb = Zab*Zbc / Zsum;   % node b to center
    Zc = Zbc*Zca / Zsum;   % node c to center
end

function s = cstr(z)
    s = sprintf('%.4f %+.4fj', real(z), imag(z));
end

function m = mag(z), m = abs(z); end
function a = angd(z), a = rad2deg(angle(z)); end

%% Plotter
function plotDeltaWye(ax,Zab,Zbc,Zca,Za,Zb,Zc)
    cla(ax);
    % Delta triangle points
    A = [0 0];
    B = [1 0];
    C = [0.3 0.8];

    % Draw delta
    plot(ax,[A(1) B(1) C(1) A(1)],[A(2) B(2) C(2) A(2)],'LineWidth',2); hold(ax,'on');
    text(ax, mean([A(1) B(1)]), mean([A(2) B(2)])-0.06, ...
        lbl('Z_{ab}',Zab), 'HorizontalAlignment','center');
    text(ax, mean([B(1) C(1)]), mean([B(2) C(2)])+0.04, ...
        lbl('Z_{bc}',Zbc), 'HorizontalAlignment','center');
    text(ax, mean([C(1) A(1)]), mean([C(2) A(2)])+0.04, ...
        lbl('Z_{ca}',Zca), 'HorizontalAlignment','center');

    % Wye center and legs
    D = mean([A;B;C],1);
    plot(ax,[D(1) A(1)],[D(2) A(2)],'LineWidth',2);
    plot(ax,[D(1) B(1)],[D(2) B(2)],'LineWidth',2);
    plot(ax,[D(1) C(1)],[D(2) C(2)],'LineWidth',2);
    scatter(ax,D(1),D(2),30,'filled');

    text(ax, mean([D(1) A(1)]), mean([D(2) A(2)])-0.05, lbl('Z_a',Za), 'HorizontalAlignment','center');
    text(ax, mean([D(1) B(1)]), mean([D(2) B(2)])+0.05, lbl('Z_b',Zb), 'HorizontalAlignment','center');
    text(ax, mean([D(1) C(1)]), mean([D(2) C(2)])+0.05, lbl('Z_c',Zc), 'HorizontalAlignment','center');

    axis(ax,[ -0.2 1.2 -0.2 1.1 ]);
    ax.XTick = []; ax.YTick = [];
    legend(ax,{'Delta','Wye legs'},'Location','northeastoutside'); legend(ax,'boxoff');
    hold(ax,'off');
end

function s = lbl(name,Z)
    s = sprintf('%s = %.3f ∠ %.2f° Ω', name, abs(Z), rad2deg(angle(Z)));
end
