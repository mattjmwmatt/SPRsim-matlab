classdef SPRsim_exported < matlab.apps.AppBase

% Properties that correspond to app components
properties (Access = public)
    UIFigure            matlab.ui.Figure
    nmLabel_5           matlab.ui.control.Label
    BioSliderLabel_2    matlab.ui.control.Label
    BioSlider           matlab.ui.control.Slider
    BioSliderLabel      matlab.ui.control.Label
    Label               matlab.ui.control.Label
    AuSlider_2          matlab.ui.control.Slider
    nmLabel_3           matlab.ui.control.Label
    RIULabel            matlab.ui.control.Label
    nmLabel_2           matlab.ui.control.Label
    nmLabel             matlab.ui.control.Label
    ButtonGroup_2       matlab.ui.container.ButtonGroup
    AutoScaleButton     matlab.ui.control.RadioButton
    NormalizedButton    matlab.ui.control.RadioButton
    ButtonGroup         matlab.ui.container.ButtonGroup
    ExternalAngleButton matlab.ui.control.RadioButton
    InternalAngleButton matlab.ui.control.RadioButton
    LambdaSlider        matlab.ui.control.Slider
    LambdaSliderLabel   matlab.ui.control.Label
    WaterSlider         matlab.ui.control.Slider
    WaterSliderLabel    matlab.ui.control.Label
    TiSlider            matlab.ui.control.Slider
    TiSliderLabel       matlab.ui.control.Label
    AuSlider            matlab.ui.control.Slider
    AuSliderLabel       matlab.ui.control.Label
    UIAxes              matlab.ui.control.UIAxes
    ContextMenu         matlab.ui.container.ContextMenu
    Menu                matlab.ui.container.Menu
    Menu2               matlab.ui.container.Menu
end

properties (Access = private)
    Ti_slider       = 1*1e-9;          % Ti film thickness (m)
    Au_slider       = 50*1e-9;         % Au film thickness (m)
    n_water         = 1.33;            % water refractive index (RIU)
    d_bio           = 2*1e-9;          % biosensor layer thickness (m)
    eps_bio         = 2.5;             % biosensor permittivity
    theta_start     = 25;              % initial sweep angle (deg)
    theta_stop      = 55;              % stop sweep angle (deg)
    lambda          = 633*1e-9;        % wavelength (m)
    selected_theta  = 'Internal Angle';
    normalize       = 'Normalized';
end

methods (Access = private)

    % Startup
    function startupFcn(app)
        app.updatePlot();
    end

    % Shared plot update helper
    function updatePlot(app)
        [RTM,theta_ref,theta_deg,~] = SPRgui_func( ...
            app.lambda, app.Au_slider, app.Ti_slider, ...
            app.n_water, app.d_bio, app.eps_bio);
        if strcmp(app.selected_theta,'Internal Angle')
            x = theta_ref;
        else
            x = theta_deg;
        end
        plot(app.UIAxes, x, RTM);
        if strcmp(app.normalize,'Normalized')
            ylim(app.UIAxes,[0 1]);
        else
            ylim(app.UIAxes,[-inf inf]);
        end
    end

    function AuSliderValueChanging(app, event)
        app.Au_slider = event.Value*1e-9;
        app.updatePlot();
    end

    function TiSliderValueChanging(app, event)
        app.Ti_slider = event.Value*1e-9;
        app.updatePlot();
    end

    function WaterSliderValueChanged(app, ~)
        app.n_water = app.WaterSlider.Value;
        app.updatePlot();
    end

    function LambdaSliderValueChanged(app, ~)
        app.lambda = app.LambdaSlider.Value*1e-9;
        app.updatePlot();
    end

    function ButtonGroupSelectionChanged(app, ~)
        app.selected_theta = app.ButtonGroup.SelectedObject.Text;
        app.updatePlot();
    end

    function ButtonGroup_2SelectionChanged(app, ~)
        app.normalize = app.ButtonGroup_2.SelectedObject.Text;
        app.updatePlot();
    end

    function BioSliderValueChanging(app, event)
        app.d_bio = event.Value*1e-9;
        app.updatePlot();
    end

    function AuSlider_2ValueChanging(app, event)
        app.eps_bio = event.Value;
        app.updatePlot();
    end

    % Create UIFigure and components
    function createComponents(app)
        app.UIFigure = uifigure('Visible','off');
        app.UIFigure.Position = [100 100 787 487];
        app.UIFigure.Name = 'SPR Simulation';

        app.UIAxes = uiaxes(app.UIFigure);
        title(app.UIAxes,'Surface Plasmon Resonance Simulation')
        xlabel(app.UIAxes,'Angle (deg)')
        ylabel(app.UIAxes,'Reflectance')
        app.UIAxes.Position = [1 200 770 288];

        % Au slider
        app.AuSliderLabel = uilabel(app.UIFigure,'HorizontalAlignment','right','Position',[32 169 25 22],'Text','Au');
        app.AuSlider = uislider(app.UIFigure,'ValueChangingFcn',createCallbackFcn(app,@AuSliderValueChanging,true),'Position',[78 178 150 3],'Value',50);
        app.nmLabel = uilabel(app.UIFigure,'Position',[236 168 25 22],'Text','nm');

        % Ti slider
        app.TiSliderLabel = uilabel(app.UIFigure,'HorizontalAlignment','right','Position',[32 117 25 22],'Text','Ti');
        app.TiSlider = uislider(app.UIFigure,'Limits',[0 20],'ValueChangingFcn',createCallbackFcn(app,@TiSliderValueChanging,true),'Position',[78 126 150 3],'Value',1);
        app.nmLabel_2 = uilabel(app.UIFigure,'Position',[237 116 25 22],'Text','nm');

        % Water slider
        app.WaterSliderLabel = uilabel(app.UIFigure,'HorizontalAlignment','right','Position',[21 62 37 22],'Text','Water');
        app.WaterSlider = uislider(app.UIFigure,'Limits',[1 2],'ValueChangedFcn',createCallbackFcn(app,@WaterSliderValueChanged,true),'Position',[79 71 150 3],'Value',1.33);
        app.RIULabel = uilabel(app.UIFigure,'Position',[238 62 26 22],'Text','RIU');

        % Lambda slider
        app.LambdaSliderLabel = uilabel(app.UIFigure,'HorizontalAlignment','right','Position',[284 62 49 22],'Text','Lambda');
        app.LambdaSlider = uislider(app.UIFigure,'Limits',[400 1500],'ValueChangedFcn',createCallbackFcn(app,@LambdaSliderValueChanged,true),'Position',[348 72 150 3],'Value',633);
        app.nmLabel_3 = uilabel(app.UIFigure,'Position',[510 62 25 22],'Text','nm');

        % Bio thickness slider
        app.BioSliderLabel = uilabel(app.UIFigure,'HorizontalAlignment','right','Position',[308 168 25 22],'Text','Bio');
        app.BioSlider = uislider(app.UIFigure,'Limits',[0 200],'ValueChangingFcn',createCallbackFcn(app,@BioSliderValueChanging,true),'Position',[347 178 150 3],'Value',1);
        app.nmLabel_5 = uilabel(app.UIFigure,'Position',[510 169 25 22],'Text','nm');

        % epsBio slider
        app.BioSliderLabel_2 = uilabel(app.UIFigure,'HorizontalAlignment','right','Position',[293 117 42 22],'Text','epsBio');
        app.AuSlider_2 = uislider(app.UIFigure,'Limits',[1 3],'ValueChangingFcn',createCallbackFcn(app,@AuSlider_2ValueChanging,true),'Position',[348 126 150 3],'Value',3);
        app.Label = uilabel(app.UIFigure,'Position',[510 117 25 22],'Text','');

        % Angle button group
        app.ButtonGroup = uibuttongroup(app.UIFigure,'SelectionChangedFcn',createCallbackFcn(app,@ButtonGroupSelectionChanged,true),'Position',[600 61 150 54]);
        app.InternalAngleButton = uiradiobutton(app.ButtonGroup,'Text','Internal Angle','Position',[11 26 95 22],'Value',true);
        app.ExternalAngleButton = uiradiobutton(app.ButtonGroup,'Text','External Angle','Position',[11 4 99 22]);

        % Scale button group
        app.ButtonGroup_2 = uibuttongroup(app.UIFigure,'SelectionChangedFcn',createCallbackFcn(app,@ButtonGroup_2SelectionChanged,true),'Position',[599 128 150 54]);
        app.NormalizedButton = uiradiobutton(app.ButtonGroup_2,'Text','Normalized','Position',[11 26 83 22],'Value',true);
        app.AutoScaleButton = uiradiobutton(app.ButtonGroup_2,'Text','Auto Scale','Position',[11 4 80 22]);

        % Context menu
        app.ContextMenu = uicontextmenu(app.UIFigure);
        app.Menu  = uimenu(app.ContextMenu,'Text','Export Data');
        app.Menu2 = uimenu(app.ContextMenu,'Text','Copy Figure');
        app.UIAxes.ContextMenu = app.ContextMenu;

        app.UIFigure.Visible = 'on';
    end
end

methods (Access = public)
    function app = SPRsim_exported
        createComponents(app)
        registerApp(app, app.UIFigure)
        runStartupFcn(app, @startupFcn)
        if nargout == 0
            clear app
        end
    end

    function delete(app)
        delete(app.UIFigure)
    end
end
end
