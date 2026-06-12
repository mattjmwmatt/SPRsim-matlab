classdef SPRsim_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        nmLabel_5            matlab.ui.control.Label
        BioSliderLabel_2     matlab.ui.control.Label
        BioSlider            matlab.ui.control.Slider
        BioSliderLabel       matlab.ui.control.Label
        Label                matlab.ui.control.Label
        AuSlider_2           matlab.ui.control.Slider
        nmLabel_3            matlab.ui.control.Label
        RIULabel             matlab.ui.control.Label
        nmLabel_2            matlab.ui.control.Label
        nmLabel              matlab.ui.control.Label
        ButtonGroup_2        matlab.ui.container.ButtonGroup
        AutoScaleButton      matlab.ui.control.RadioButton
        NormalizedButton     matlab.ui.control.RadioButton
        ButtonGroup          matlab.ui.container.ButtonGroup
        ExternalAngleButton  matlab.ui.control.RadioButton
        InternalAngleButton  matlab.ui.control.RadioButton
        LambdaSlider         matlab.ui.control.Slider
        LambdaSliderLabel    matlab.ui.control.Label
        WaterSlider          matlab.ui.control.Slider
        WaterSliderLabel     matlab.ui.control.Label
        TiSlider             matlab.ui.control.Slider
        TiSliderLabel        matlab.ui.control.Label
        AuSlider             matlab.ui.control.Slider
        AuSliderLabel        matlab.ui.control.Label
        UIAxes               matlab.ui.control.UIAxes
        ContextMenu          matlab.ui.container.ContextMenu
        Menu                 matlab.ui.container.Menu
        Menu2                matlab.ui.container.Menu
    end


    properties (Access = private)
        Ti_slider = 1*1e-9; % Ti film thickness nm
        Au_slider = 50*1e-9; % Au film thickness nm
        n_water = 1.33; % water refraction index RIU
        d_bio = 2*1e-9; % biosensor layer thickness nm
        eps_bio = 2.5; % biosensor epsilon
        theta_start = 25; %initial sweep angle
        theta_stop = 55;% stop angle
        lambda = 633*1e-9; %impinging wavelenght in nm
        selected_theta = 'Internal Angle'; % selected button for SPR internal or external angle
        normalize = 'Normalized'; % set graph y limits to 0 - 1
    end

    properties (Access = public)
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end

        % Value changing function: AuSlider
        function AuSliderValueChanging(app, event)
            app.Au_slider = event.Value*1e-9;

            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end

        % Value changing function: TiSlider
        function TiSliderValueChanging(app, event)
            app.Ti_slider = event.Value*1e-9;

            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end

        % Callback function
        function StartButtonValueChanged(app, event)

        end

        % Value changed function: WaterSlider
        function WaterSliderValueChanged(app, event)
            app.n_water = app.WaterSlider.Value;


            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end

        % Callback function
        function StartSliderValueChanged(app, event)
            %xlim(app.UIAxes,[app.theta_start,app.theta_stop])
        end

        % Value changed function: LambdaSlider
        function LambdaSliderValueChanged(app, event)
            app.lambda = app.LambdaSlider.Value*1e-9;

            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            app.selected_theta = app.ButtonGroup.SelectedObject.Text;

            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end

        % Selection changed function: ButtonGroup_2
        function ButtonGroup_2SelectionChanged(app, event)
            app.normalize = app.ButtonGroup_2.SelectedObject.Text;

            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end

        end

        % Callback function
        function SystemLogSizeChanged(app, event)
            position = app.SystemLog.Position;

        end

        % Value changing function: BioSlider
        function BioSliderValueChanging(app, event)
            app.d_bio = event.Value*1e-9;

            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end

        % Value changing function: AuSlider_2
        function AuSlider_2ValueChanging(app, event)
            app.eps_bio = event.Value;

            lambda = app.lambda;
            n_water = app.n_water;
            d_ti = app.Ti_slider;
            d_au = app.Au_slider;
            d_bio = app.d_bio;
            eps_bio = app.eps_bio;
            [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio);

            if(strcmp(app.selected_theta,'Internal Angle'))
                x = theta_ref;
            elseif(strcmp(app.selected_theta,'External Angle'))
                x = theta_deg;
            end
            y = RTM;
            plot(app.UIAxes,x,y);
            if(strcmp(app.normalize,'Normalized'))
                ylim(app.UIAxes,[0 1]);
            else
                ylim(app.UIAxes,[-inf inf]);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 787 487];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Surface Plasmon Resonance Simulation')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [1 200 770 288];

            % Create AuSliderLabel
            app.AuSliderLabel = uilabel(app.UIFigure);
            app.AuSliderLabel.HorizontalAlignment = 'right';
            app.AuSliderLabel.Position = [32 169 25 22];
            app.AuSliderLabel.Text = 'Au';

            % Create AuSlider
            app.AuSlider = uislider(app.UIFigure);
            app.AuSlider.ValueChangingFcn = createCallbackFcn(app, @AuSliderValueChanging, true);
            app.AuSlider.Position = [78 178 150 3];
            app.AuSlider.Value = 50;

            % Create TiSliderLabel
            app.TiSliderLabel = uilabel(app.UIFigure);
            app.TiSliderLabel.HorizontalAlignment = 'right';
            app.TiSliderLabel.Position = [32 117 25 22];
            app.TiSliderLabel.Text = 'Ti';

            % Create TiSlider
            app.TiSlider = uislider(app.UIFigure);
            app.TiSlider.Limits = [0 20];
            app.TiSlider.ValueChangingFcn = createCallbackFcn(app, @TiSliderValueChanging, true);
            app.TiSlider.Position = [78 126 150 3];
            app.TiSlider.Value = 1;

            % Create WaterSliderLabel
            app.WaterSliderLabel = uilabel(app.UIFigure);
            app.WaterSliderLabel.HorizontalAlignment = 'right';
            app.WaterSliderLabel.Position = [21 62 37 22];
            app.WaterSliderLabel.Text = 'Water';

            % Create WaterSlider
            app.WaterSlider = uislider(app.UIFigure);
            app.WaterSlider.Limits = [1 2];
            app.WaterSlider.ValueChangedFcn = createCallbackFcn(app, @WaterSliderValueChanged, true);
            app.WaterSlider.Position = [79 71 150 3];
            app.WaterSlider.Value = 1.33;

            % Create LambdaSliderLabel
            app.LambdaSliderLabel = uilabel(app.UIFigure);
            app.LambdaSliderLabel.HorizontalAlignment = 'right';
            app.LambdaSliderLabel.Position = [284 62 49 22];
            app.LambdaSliderLabel.Text = 'Lambda';

            % Create LambdaSlider
            app.LambdaSlider = uislider(app.UIFigure);
            app.LambdaSlider.Limits = [400 1500];
            app.LambdaSlider.ValueChangedFcn = createCallbackFcn(app, @LambdaSliderValueChanged, true);
            app.LambdaSlider.Position = [348 72 150 3];
            app.LambdaSlider.Value = 633;

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.Position = [600 61 150 54];

            % Create InternalAngleButton
            app.InternalAngleButton = uiradiobutton(app.ButtonGroup);
            app.InternalAngleButton.Text = 'Internal Angle';
            app.InternalAngleButton.Position = [11 26 95 22];
            app.InternalAngleButton.Value = true;

            % Create ExternalAngleButton
            app.ExternalAngleButton = uiradiobutton(app.ButtonGroup);
            app.ExternalAngleButton.Text = 'External Angle';
            app.ExternalAngleButton.Position = [11 4 99 22];

            % Create ButtonGroup_2
            app.ButtonGroup_2 = uibuttongroup(app.UIFigure);
            app.ButtonGroup_2.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroup_2SelectionChanged, true);
            app.ButtonGroup_2.Position = [599 128 150 54];

            % Create NormalizedButton
            app.NormalizedButton = uiradiobutton(app.ButtonGroup_2);
            app.NormalizedButton.Text = 'Normalized';
            app.NormalizedButton.Position = [11 26 83 22];
            app.NormalizedButton.Value = true;

            % Create AutoScaleButton
            app.AutoScaleButton = uiradiobutton(app.ButtonGroup_2);
            app.AutoScaleButton.Text = 'Auto Scale';
            app.AutoScaleButton.Position = [11 4 80 22];

            % Create nmLabel
            app.nmLabel = uilabel(app.UIFigure);
            app.nmLabel.Position = [236 168 25 22];
            app.nmLabel.Text = 'nm';

            % Create nmLabel_2
            app.nmLabel_2 = uilabel(app.UIFigure);
            app.nmLabel_2.Position = [237 116 25 22];
            app.nmLabel_2.Text = 'nm';

            % Create RIULabel
            app.RIULabel = uilabel(app.UIFigure);
            app.RIULabel.Position = [238 62 26 22];
            app.RIULabel.Text = 'RIU';

            % Create nmLabel_3
            app.nmLabel_3 = uilabel(app.UIFigure);
            app.nmLabel_3.Position = [510 62 25 22];
            app.nmLabel_3.Text = 'nm';

            % Create AuSlider_2
            app.AuSlider_2 = uislider(app.UIFigure);
            app.AuSlider_2.Limits = [1 3];
            app.AuSlider_2.ValueChangingFcn = createCallbackFcn(app, @AuSlider_2ValueChanging, true);
            app.AuSlider_2.Position = [348 126 150 3];
            app.AuSlider_2.Value = 3;

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [510 117 25 22];
            app.Label.Text = '';

            % Create BioSliderLabel
            app.BioSliderLabel = uilabel(app.UIFigure);
            app.BioSliderLabel.HorizontalAlignment = 'right';
            app.BioSliderLabel.Position = [308 168 25 22];
            app.BioSliderLabel.Text = 'Bio';

            % Create BioSlider
            app.BioSlider = uislider(app.UIFigure);
            app.BioSlider.Limits = [0 200];
            app.BioSlider.ValueChangingFcn = createCallbackFcn(app, @BioSliderValueChanging, true);
            app.BioSlider.Position = [347 178 150 3];
            app.BioSlider.Value = 1;

            % Create BioSliderLabel_2
            app.BioSliderLabel_2 = uilabel(app.UIFigure);
            app.BioSliderLabel_2.HorizontalAlignment = 'right';
            app.BioSliderLabel_2.Position = [293 117 42 22];
            app.BioSliderLabel_2.Text = 'epsBio';

            % Create nmLabel_5
            app.nmLabel_5 = uilabel(app.UIFigure);
            app.nmLabel_5.Position = [510 169 25 22];
            app.nmLabel_5.Text = 'nm';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.UIFigure);

            % Create Menu
            app.Menu = uimenu(app.ContextMenu);
            app.Menu.Text = 'Menu';

            % Create Menu2
            app.Menu2 = uimenu(app.ContextMenu);
            app.Menu2.Text = 'Menu2';
            
            % Assign app.ContextMenu
            app.UIAxes.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SPRsim_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end