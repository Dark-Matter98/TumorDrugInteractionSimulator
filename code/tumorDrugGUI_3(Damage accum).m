function advancedTumorGUI()
    % Create the main figure window
    fig = figure('Name', 'Tumor-Drug Interaction Simulator', ...
                'Position', [100, 100, 1200, 800], ...
                'NumberTitle', 'off', ...
                'MenuBar', 'none', ...
                'Resize', 'on');
    
    % Create panel structure
    createPanels(fig);
    
    % Initialize global variables to store simulation data
    initializeAppData(fig);
end

function initializeAppData(fig)
    % Store application data
    setappdata(fig, 'simData', struct());
end

function createPanels(fig)
    % Create a panel for controls on the left
    controlPanel = uipanel('Parent', fig, ...
                         'Title', 'Model Parameters', ...
                         'Position', [0.01, 0.01, 0.25, 0.98]);
    
    % Create parameter controls
    createParameterControls(controlPanel);
    
    % Create a panel for results on the right
    resultsPanel = uipanel('Parent', fig, ...
                         'Title', 'Simulation Results', ...
                         'Position', [0.27, 0.01, 0.72, 0.98]);
    
    % Create visualization components
    createVisualizationComponents(fig, resultsPanel);
end

function createParameterControls(panel)
    % Tumor parameters section
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'TUMOR PARAMETERS', ...
              'Position', [10, 720, 250, 20], ...
              'FontWeight', 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Tumor radius
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Tumor Radius (μm):', ...
              'Position', [10, 690, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
              'String', '500', ...
              'Position', [170, 690, 60, 20], ...
              'Tag', 'rmax');
    
    % Cell growth rate
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Cell Growth Rate (1/h):', ...
              'Position', [10, 660, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 0.001, 'Max', 0.03, 'Value', 0.01, ...
              'Position', [10, 640, 160, 20], ...
              'Tag', 'growth', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '0.010', ...
              'Position', [180, 660, 60, 20], ...
              'Tag', 'growthDisplay');
    
    % Maximum density
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Maximum Density:', ...
              'Position', [10, 610, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
              'String', '1.0', ...
              'Position', [170, 610, 60, 20], ...
              'Tag', 'rhoMax');
    
    % Drug parameters section
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'DRUG PARAMETERS', ...
              'Position', [10, 570, 250, 20], ...
              'FontWeight', 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Drug diffusion
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Drug Diffusion (μm²/h):', ...
              'Position', [10, 540, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 1e3, 'Max', 1e5, 'Value', 5e4, ...
              'Position', [10, 520, 160, 20], ...
              'Tag', 'diffusion', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '5.0e+04', ...
              'Position', [180, 540, 60, 20], ...
              'Tag', 'diffusionDisplay');
    
    % Drug elimination
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Drug Elimination (1/h):', ...
              'Position', [10, 490, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 0.01, 'Max', 0.05, 'Value', 0.02, ...
              'Position', [10, 470, 160, 20], ...
              'Tag', 'elimination', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '0.020', ...
              'Position', [180, 490, 60, 20], ...
              'Tag', 'eliminationDisplay');
    
    % Drug efficacy
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Drug Efficacy:', ...
              'Position', [10, 440, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 0.1, 'Max', 1.0, 'Value', 0.7, ...
              'Position', [10, 420, 160, 20], ...
              'Tag', 'efficacy', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '0.700', ...
              'Position', [180, 440, 60, 20], ...
              'Tag', 'efficacyDisplay');
    
    % Penetration depth
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Penetration Depth (μm):', ...
              'Position', [10, 390, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 50, 'Max', 200, 'Value', 120, ...
              'Position', [10, 370, 160, 20], ...
              'Tag', 'penetration', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '120', ...
              'Position', [180, 390, 60, 20], ...
              'Tag', 'penetrationDisplay');
    
    % Oxygen and microenvironment section
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'MICROENVIRONMENT', ...
              'Position', [10, 340, 250, 20], ...
              'FontWeight', 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Oxygen diffusion
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'O₂ Diffusion (μm²/h):', ...
              'Position', [10, 310, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 1e4, 'Max', 5e5, 'Value', 2.5e5, ...
              'Position', [10, 290, 160, 20], ...
              'Tag', 'o2diff', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '2.5e+05', ...
              'Position', [180, 310, 60, 20], ...
              'Tag', 'o2diffDisplay');
    
    % Oxygen consumption
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'O₂ Consumption (1/h):', ...
              'Position', [10, 260, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 0.1, 'Max', 1.0, 'Value', 0.3, ...
              'Position', [10, 240, 160, 20], ...
              'Tag', 'o2cons', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '0.300', ...
              'Position', [180, 260, 60, 20], ...
              'Tag', 'o2consDisplay');
    
    % Hypoxia threshold
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Hypoxia Threshold:', ...
              'Position', [10, 210, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 0.1, 'Max', 0.5, 'Value', 0.3, ...
              'Position', [10, 190, 160, 20], ...
              'Tag', 'hypoxia', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '0.300', ...
              'Position', [180, 210, 60, 20], ...
              'Tag', 'hypoxiaDisplay');
    
    % Damage accumulation section
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'DAMAGE ACCUMULATION', ...
              'Position', [10, 160, 250, 20], ...
              'FontWeight', 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Damage coefficient
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Damage per Treatment:', ...
              'Position', [10, 130, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 0.01, 'Max', 0.2, 'Value', 0.1, ...
              'Position', [10, 110, 160, 20], ...
              'Tag', 'damageCoeff', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '0.100', ...
              'Position', [180, 130, 60, 20], ...
              'Tag', 'damageCoeffDisplay');
    
    % Damage recovery
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'Damage Recovery (1/h):', ...
              'Position', [10, 80, 150, 20], ...
              'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'slider', ...
              'Min', 0.001, 'Max', 0.01, 'Value', 0.005, ...
              'Position', [10, 60, 160, 20], ...
              'Tag', 'damageRecovery', ...
              'Callback', @updateValueDisplay);
    
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', '0.005', ...
              'Position', [180, 80, 60, 20], ...
              'Tag', 'damageRecoveryDisplay');
    
    % Dosing section
    uicontrol('Parent', panel, 'Style', 'text', ...
              'String', 'TREATMENT SCHEDULE', ...
              'Position', [10, 30, 250, 20], ...
              'FontWeight', 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Dosing schedule
    doseSchedules = {'Every 20 hours', 'Every 10 hours', 'Daily (24h)', 'Weekly-equivalent (168/7h)'};
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
              'String', doseSchedules, ...
              'Position', [10, 5, 150, 20], ...
              'Tag', 'doseSchedule');
    
    % Start simulation button
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
              'String', 'Run Simulation', ...
              'Position', [170, 5, 100, 20], ...
              'Callback', @startSimulation, ...
              'Tag', 'startButton');
end

function createVisualizationComponents(fig, panel)
    % Create tab group for different visualizations
    tabGroup = uitabgroup('Parent', panel, 'Position', [0.02, 0.02, 0.96, 0.96]);
    
    % Tab 1: Average values over time
    tab1 = uitab('Parent', tabGroup, 'Title', 'Average Values');
    
    y_gap = 0.05; % Add vertical gaps between plots
    height = 0.18; % Smaller height

    % Now position everything nicely
    ax1 = axes('Parent', tab1, 'Position', [0.1, 0.74, 0.8, height]);
    title(ax1, 'Average Drug Concentration vs Time', 'FontSize', 12, 'Units', 'normalized', 'Position', [0.5, 1.08, 0]);
    xlabel(ax1, 'Time (hours)', 'FontSize', 11);
    ylabel(ax1, 'Drug Concentration', 'FontSize', 11);
    xlim(ax1, [0 168]);
    ylim(ax1, [0 0.5]);
    grid(ax1, 'on');
    
    ax2 = axes('Parent', tab1, 'Position', [0.1, 0.74-height-y_gap, 0.8, height]);
    title(ax2, 'Average Tumor Cell Density vs Time', 'FontSize', 12, 'Units', 'normalized', 'Position', [0.5, 1.08, 0]);
    xlabel(ax2, 'Time (hours)', 'FontSize', 11);
    ylabel(ax2, 'Cell Density', 'FontSize', 11);
    xlim(ax2, [0 168]);
    ylim(ax2, [0 0.5]);
    grid(ax2, 'on');
    
    ax3 = axes('Parent', tab1, 'Position', [0.1, 0.74-2*(height+y_gap), 0.8, height]);
    title(ax3, 'Average Oxygen Level vs Time', 'FontSize', 12, 'Units', 'normalized', 'Position', [0.5, 1.08, 0]);
    xlabel(ax3, 'Time (hours)', 'FontSize', 11);
    ylabel(ax3, 'Oxygen Level', 'FontSize', 11);
    xlim(ax3, [0 168]);
    ylim(ax3, [0 1.0]);
    grid(ax3, 'on');
    
    ax4 = axes('Parent', tab1, 'Position', [0.1, 0.74-3*(height+y_gap), 0.8, height]);
    title(ax4, 'Average Cellular Damage vs Time', 'FontSize', 12, 'Units', 'normalized', 'Position', [0.5, 1.08, 0]);
    xlabel(ax4, 'Time (hours)', 'FontSize', 11);
    ylabel(ax4, 'Accumulated Damage', 'FontSize', 11);
    xlim(ax4, [0 168]);
    ylim(ax4, [0 0.3]);
    grid(ax4, 'on');
    
    % Store axis references for later use
    setappdata(fig, 'ax1', ax1);
    setappdata(fig, 'ax2', ax2);
    setappdata(fig, 'ax3', ax3);
    setappdata(fig, 'ax4', ax4);
    
    % Tab 2: Spatial profiles
    tab2 = uitab('Parent', tabGroup, 'Title', 'Spatial Profiles');
    
    % Create axes for spatial profiles
    ax5 = axes('Parent', tab2, 'Position', [0.1, 0.75, 0.38, 0.2]);
    title(ax5, 'Drug Concentration Spatial Profile', 'FontSize', 12);
    xlabel(ax5, 'Radius (μm)', 'FontSize', 11);
    ylabel(ax5, 'Drug Concentration', 'FontSize', 11);
    grid(ax5, 'on');
    
    ax6 = axes('Parent', tab2, 'Position', [0.58, 0.75, 0.38, 0.2]);
    title(ax6, 'Cell Density Spatial Profile', 'FontSize', 12);
    xlabel(ax6, 'Radius (μm)', 'FontSize', 11);
    ylabel(ax6, 'Cell Density', 'FontSize', 11);
    grid(ax6, 'on');
    
    ax7 = axes('Parent', tab2, 'Position', [0.1, 0.45, 0.38, 0.2]);
    title(ax7, 'Oxygen Spatial Profile', 'FontSize', 12);
    xlabel(ax7, 'Radius (μm)', 'FontSize', 11);
    ylabel(ax7, 'Oxygen Level', 'FontSize', 11);
    grid(ax7, 'on');
    
    ax8 = axes('Parent', tab2, 'Position', [0.58, 0.45, 0.38, 0.2]);
    title(ax8, 'Damage Spatial Profile', 'FontSize', 12);
    xlabel(ax8, 'Radius (μm)', 'FontSize', 11);
    ylabel(ax8, 'Accumulated Damage', 'FontSize', 11);
    grid(ax8, 'on');
    
    % Store axis references for spatial plots
    setappdata(fig, 'ax5', ax5);
    setappdata(fig, 'ax6', ax6);
    setappdata(fig, 'ax7', ax7);
    setappdata(fig, 'ax8', ax8);
    
    % Tab 3: Heatmaps
    tab3 = uitab('Parent', tabGroup, 'Title', 'Spatiotemporal Dynamics');
    
    % Create axes for heatmaps
    ax9 = axes('Parent', tab3, 'Position', [0.1, 0.75, 0.38, 0.2]);
    title(ax9, 'Drug Concentration Spatiotemporal Profile', 'FontSize', 12);
    xlabel(ax9, 'Time (hours)', 'FontSize', 11);
    ylabel(ax9, 'Radius (μm)', 'FontSize', 11);
    
    ax10 = axes('Parent', tab3, 'Position', [0.58, 0.75, 0.38, 0.2]);
    title(ax10, 'Cell Density Spatiotemporal Profile', 'FontSize', 12);
    xlabel(ax10, 'Time (hours)', 'FontSize', 11);
    ylabel(ax10, 'Radius (μm)', 'FontSize', 11);
    
    ax11 = axes('Parent', tab3, 'Position', [0.1, 0.45, 0.38, 0.2]);
    title(ax11, 'Oxygen Level Spatiotemporal Profile', 'FontSize', 12);
    xlabel(ax11, 'Time (hours)', 'FontSize', 11);
    ylabel(ax11, 'Radius (μm)', 'FontSize', 11);
    
    ax12 = axes('Parent', tab3, 'Position', [0.58, 0.45, 0.38, 0.2]);
    title(ax12, 'Cellular Damage Spatiotemporal Profile', 'FontSize', 12);
    xlabel(ax12, 'Time (hours)', 'FontSize', 11);
    ylabel(ax12, 'Radius (μm)', 'FontSize', 11);
    
    % Store axis references for heatmaps
    setappdata(fig, 'ax9', ax9);
    setappdata(fig, 'ax10', ax10);
    setappdata(fig, 'ax11', ax11);
    setappdata(fig, 'ax12', ax12);
    
    % Status text at the bottom
    uicontrol('Parent', panel, 'Style', 'text', ...
              'Position', [400, 5, 300, 20], ...
              'String', 'Ready to run simulation', ...
              'Tag', 'statusText', ...
              'HorizontalAlignment', 'center');
end

function updateValueDisplay(src, ~)
    % Get the value from the slider
    value = get(src, 'Value');
    
    % Get the tag of the slider
    sliderTag = get(src, 'Tag');
    
    % Determine the display tag based on the slider tag
    displayTag = [sliderTag 'Display'];
    
    % Find the display object
    displayObj = findobj('Tag', displayTag);
    
    % Format the value appropriately based on the parameter
    switch sliderTag
        case {'diffusion', 'o2diff'}
            % Scientific notation for large values
            formattedValue = sprintf('%.1e', value);
        case {'growth', 'elimination', 'efficacy', 'o2cons', 'hypoxia', 'damageCoeff', 'damageRecovery'}
            % Fixed precision for small values
            formattedValue = sprintf('%.3f', value);
        case {'penetration'}
            % Integer for distance values
            formattedValue = sprintf('%d', round(value));
        otherwise
            formattedValue = sprintf('%.2f', value);
    end
    
    % Update the display
    set(displayObj, 'String', formattedValue);
end

function startSimulation(src, ~)
    % Get the figure handle
    fig = ancestor(src, 'figure');
    
    % Get parameter values from UI controls
    rmax = str2double(get(findobj(fig, 'Tag', 'rmax'), 'String'));
    D = get(findobj(fig, 'Tag', 'diffusion'), 'Value');
    k = get(findobj(fig, 'Tag', 'elimination'), 'Value');
    g = get(findobj(fig, 'Tag', 'growth'), 'Value');
    m = get(findobj(fig, 'Tag', 'efficacy'), 'Value');
    rho_max = str2double(get(findobj(fig, 'Tag', 'rhoMax'), 'String'));
    penetration_depth = get(findobj(fig, 'Tag', 'penetration'), 'Value');
    O2_diff = get(findobj(fig, 'Tag', 'o2diff'), 'Value');
    O2_cons = get(findobj(fig, 'Tag', 'o2cons'), 'Value');
    hypoxia_threshold = get(findobj(fig, 'Tag', 'hypoxia'), 'Value');
    damage_coeff = get(findobj(fig, 'Tag', 'damageCoeff'), 'Value');
    damage_recovery = get(findobj(fig, 'Tag', 'damageRecovery'), 'Value');
    
    % Get dosing schedule
    scheduleIdx = get(findobj(fig, 'Tag', 'doseSchedule'), 'Value');
    scheduleOptions = [20, 10, 24, 168/7]; % Hours between doses
    doseInterval = scheduleOptions(scheduleIdx);
    
    % Update status text
    statusText = findobj(fig, 'Tag', 'statusText');
    set(statusText, 'String', 'Initializing simulation...');
    drawnow;
    
    % Disable run button during simulation
    runButton = findobj(fig, 'Tag', 'startButton');
    set(runButton, 'Enable', 'off');
    
    % Run the simulation with the selected parameters
    runSimulation(fig, rmax, D, k, g, m, rho_max, penetration_depth, O2_diff, O2_cons, ...
                 hypoxia_threshold, damage_coeff, damage_recovery, doseInterval);
    
    % Re-enable run button
    set(runButton, 'Enable', 'on');
    
    % Update status
    set(statusText, 'String', 'Simulation complete!');
end

function runSimulation(fig, rmax, D, k, g, m, rho_max, penetration_depth, O2_diff, O2_cons, ...
                       hypoxia_threshold, damage_coeff, damage_recovery, doseInterval)
    % Get axis handles
    ax1 = getappdata(fig, 'ax1'); % Drug concentration average
    ax2 = getappdata(fig, 'ax2'); % Cell density average
    ax3 = getappdata(fig, 'ax3'); % Oxygen average
    ax4 = getappdata(fig, 'ax4'); % Damage average
    
    ax5 = getappdata(fig, 'ax5'); % Drug spatial
    ax6 = getappdata(fig, 'ax6'); % Cell spatial
    ax7 = getappdata(fig, 'ax7'); % Oxygen spatial
    ax8 = getappdata(fig, 'ax8'); % Damage spatial
    
    ax9 = getappdata(fig, 'ax9');  % Drug heatmap
    ax10 = getappdata(fig, 'ax10'); % Cell heatmap
    ax11 = getappdata(fig, 'ax11'); % Oxygen heatmap
    ax12 = getappdata(fig, 'ax12'); % Damage heatmap
    
    % Clear current plots
    cla(ax1); cla(ax2); cla(ax3); cla(ax4);
    cla(ax5); cla(ax6); cla(ax7); cla(ax8);
    cla(ax9); cla(ax10); cla(ax11); cla(ax12);
    
    % Get status text handle
    statusText = findobj(fig, 'Tag', 'statusText');
    
    % Simulation parameters
    tmax = 168;
    dt = 0.05; % Balance between accuracy and speed
    t = 0:dt:tmax;
    nt = length(t);
    
    nr = 50;
    dr = rmax/nr;
    r = linspace(dr, rmax, nr);
    
    % Dosing times
    dose_times = 20:doseInterval:tmax;
    dose_amount = 1.0;
    
    % Initialize arrays
    C = zeros(nt, nr);
    rho = zeros(nt, nr);
    O2 = zeros(nt, nr);
    damage = zeros(nt, nr);
    
    % Initial conditions
    for i = 1:nr
        rho(1,i) = 0.5 * (1 - 0.2*(r(i)/rmax)^2);
        O2(1,i) = 0.5 + 0.5*(r(i)/rmax);
    end
    
    % For averaging
    vol_elements = r.^2;
    total_vol = sum(vol_elements);
    
    % Calculate initial averages
    C_avg = zeros(nt, 1);
    rho_avg = zeros(nt, 1);
    O2_avg = zeros(nt, 1);
    damage_avg = zeros(nt, 1);
    
    C_avg(1) = sum(C(1,:) .* vol_elements) / total_vol;
    rho_avg(1) = sum(rho(1,:) .* vol_elements) / total_vol;
    O2_avg(1) = sum(O2(1,:) .* vol_elements) / total_vol;
    damage_avg(1) = sum(damage(1,:) .* vol_elements) / total_vol;
    
    % Initialize plots with empty data
    drugLine = plot(ax1, t(1), C_avg(1), 'b-', 'LineWidth', 2);
    cellLine = plot(ax2, t(1), rho_avg(1), 'r-', 'LineWidth', 2);
    oxygenLine = plot(ax3, t(1), O2_avg(1), 'g-', 'LineWidth', 2);
    damageLine = plot(ax4, t(1), damage_avg(1), 'm-', 'LineWidth', 2);
    
    % Setup for implicit methods
    alpha = dt * D / (dr^2);
    A_drug = diag(1 + 2*alpha * ones(nr, 1)) + diag(-alpha * ones(nr-1, 1), -1) + diag(-alpha * ones(nr-1, 1), 1);
    
    alpha_O2 = dt * O2_diff / (dr^2);
    A_O2 = diag(1 + 2*alpha_O2 * ones(nr, 1)) + diag(-alpha_O2 * ones(nr-1, 1), -1) + diag(-alpha_O2 * ones(nr-1, 1), 1);
    
    % Main simulation loop
    updateFreq = 50; % Update visualization periodically
    
    % To track time points for spatial profiles
    selected_times = [1, 25, 50, 100, 150];
    time_data = {}; % Cell array to store data at selected times
    
    % For heatmap visualization
    time_subsample = [];
    heatmap_data = struct('drug', [], 'cell', [], 'oxygen', [], 'damage', []);
    
    for n = 1:nt-1
        % Update status
        if mod(n, round(nt/10)) == 0
            progress = 100 * n / nt;
            set(statusText, 'String', sprintf('Progress: %.0f%%', progress));
            drawnow;
        end
        
        % Apply drug dose if needed
        if any(abs(t(n) - dose_times) < dt/2)
            for i = 1:nr
                dist_from_surface = rmax - r(i);
                C(n,i) = C(n,i) + dose_amount * exp(-dist_from_surface/penetration_depth);
                damage(n,i) = damage(n,i) + damage_coeff * exp(-dist_from_surface/penetration_depth);
            end
        end
        
        % Update drug concentration
        A_drug_current = A_drug;
        C_after_consumption = C(n,:)' .* (1 - dt*k);
        
        A_drug_current(nr,nr-1) = -2*alpha;
        A_drug_current(nr,nr) = 1 + 2*alpha;
        
        C(n+1,:) = A_drug_current \ C_after_consumption;
        
        % Update damage
        damage(n+1,:) = damage(n,:) * (1 - dt * damage_recovery);
        damage(n+1,:) = max(0, damage(n+1,:));
        
        % Update cell density
        for i = 1:nr
            O2_factor = max(0.2, min(1.0, O2(n,i) / hypoxia_threshold));
            damage_factor = max(0.1, 1.0 - damage(n,i));
            
            growth_term = g * rho(n,i) * (1 - rho(n,i)/rho_max) * damage_factor;
            death_factor = 1.0 + damage(n,i);
            death_term = m * C(n,i) * rho(n,i) * O2_factor * death_factor;
            
            rho(n+1,i) = rho(n,i) + dt * (growth_term - death_term);
            rho(n+1,i) = max(0, rho(n+1,i));
        end
        
        % Update oxygen
        A_O2_current = A_O2;
        O2_after_consumption = zeros(nr, 1);
        
        for i = 1:nr
            consumption_rate = O2_cons * rho(n,i);
            O2_after_consumption(i) = O2(n,i) * (1 - dt * consumption_rate);
        end
        
        A_O2_current(nr,nr-1) = 0;
        A_O2_current(nr,nr) = 1;
        O2_after_consumption(nr) = 1.0;
        
        O2(n+1,:) = A_O2_current \ O2_after_consumption;
        O2(n+1,:) = max(0, min(1, O2(n+1,:)));
        
        % Calculate averages
        C_avg(n+1) = sum(C(n+1,:) .* vol_elements) / total_vol;
        rho_avg(n+1) = sum(rho(n+1,:) .* vol_elements) / total_vol;
        O2_avg(n+1) = sum(O2(n+1,:) .* vol_elements) / total_vol;
        damage_avg(n+1) = sum(damage(n+1,:) .* vol_elements) / total_vol;
        
        % Check if this is one of our selected time points
        for i = 1:length(selected_times)
            if abs(t(n) - selected_times(i)) < dt/2
                time_data{i} = struct('t', t(n), 'C', C(n,:), 'rho', rho(n,:), ...
                                    'O2', O2(n,:), 'damage', damage(n,:));
            end
        end
        
        % Collect data for heatmaps (downsample for efficiency)
        if mod(n, round(nt/100)) == 0
            time_subsample = [time_subsample, n];
            if isempty(heatmap_data.drug)
                heatmap_data.drug = C(n,:)';
                heatmap_data.cell = rho(n,:)';
                heatmap_data.oxygen = O2(n,:)';
                heatmap_data.damage = damage(n,:)';
            else
                heatmap_data.drug = [heatmap_data.drug, C(n,:)'];
                heatmap_data.cell = [heatmap_data.cell, rho(n,:)'];
                heatmap_data.oxygen = [heatmap_data.oxygen, O2(n,:)'];
                heatmap_data.damage = [heatmap_data.damage, damage(n,:)'];
            end
        end
        
        % Update visualization periodically
        if mod(n, updateFreq) == 0
            % Update time series plots
            set(drugLine, 'XData', t(1:n), 'YData', C_avg(1:n));
            set(cellLine, 'XData', t(1:n), 'YData', rho_avg(1:n));
            set(oxygenLine, 'XData', t(1:n), 'YData', O2_avg(1:n));
            set(damageLine, 'XData', t(1:n), 'YData', damage_avg(1:n));
            
            % Adjust y-axis limits if needed
            if max(C_avg(1:n)) > 0
                ylim(ax1, [0, max(C_avg(1:n))*1.1]);
            end
            if max(rho_avg(1:n)) > 0
                ylim(ax2, [0, max(rho_avg(1:n))*1.1]);
            end
            
            drawnow;
        end
    end
    
    % Final update of average plots
    set(drugLine, 'XData', t, 'YData', C_avg);
    set(cellLine, 'XData', t, 'YData', rho_avg);
    set(oxygenLine, 'XData', t, 'YData', O2_avg);
    set(damageLine, 'XData', t, 'YData', damage_avg);
    
    % Update spatial profiles
    updateSpatialProfiles(ax5, ax6, ax7, ax8, r, time_data, selected_times);
    
    % Update heatmaps
    updateHeatmaps(ax9, ax10, ax11, ax12, t(time_subsample), r, heatmap_data);
    
    % Store simulation data in app data
    simData = struct('t', t, 'r', r, 'C', C, 'rho', rho, 'O2', O2, 'damage', damage, ...
                    'C_avg', C_avg, 'rho_avg', rho_avg, 'O2_avg', O2_avg, 'damage_avg', damage_avg);
    setappdata(fig, 'simData', simData);
end

function updateSpatialProfiles(ax5, ax6, ax7, ax8, r, time_data, selected_times)
    % Clear axes
    cla(ax5); cla(ax6); cla(ax7); cla(ax8);
    
    % Colors for different time points
    colors = {'b', 'r', 'y', 'c', 'm'};
    
    % Plot spatial profiles for each time point that has data
    legends = {};
    for i = 1:length(time_data)
        if ~isempty(time_data{i})
            data = time_data{i};
            % Drug concentration
            axes(ax5);
            hold on;
            plot(r, data.C, colors{i}, 'LineWidth', 2);
            
            % Cell density
            axes(ax6);
            hold on;
            plot(r, data.rho, colors{i}, 'LineWidth', 2);
            
            % Oxygen
            axes(ax7);
            hold on;
            plot(r, data.O2, colors{i}, 'LineWidth', 2);
            
            % Damage
            axes(ax8);
            hold on;
            plot(r, data.damage, colors{i}, 'LineWidth', 2);
            
            legends{end+1} = sprintf('t=%.0f h', data.t);
        end
    end
    
    % Add legends
    if ~isempty(legends)
        legend(ax5, legends, 'Location', 'NorthWest');
    end
    
    % Reset hold states
    hold(ax5, 'off');
    hold(ax6, 'off');
    hold(ax7, 'off');
    hold(ax8, 'off');
end

function updateHeatmaps(ax9, ax10, ax11, ax12, t_sub, r, data)
    % Drug concentration heatmap
    axes(ax9);
    imagesc(t_sub, r, data.drug);
    set(gca, 'YDir', 'normal');
    colorbar;
    title('Drug Concentration Spatiotemporal Profile', 'FontSize', 12);
    xlabel('Time (hours)', 'FontSize', 11);
    ylabel('Radius (μm)', 'FontSize', 11);
    
    % Cell density heatmap
    axes(ax10);
    imagesc(t_sub, r, data.cell);
    set(gca, 'YDir', 'normal');
    colorbar;
    title('Cell Density Spatiotemporal Profile', 'FontSize', 12);
    xlabel('Time (hours)', 'FontSize', 11);
    ylabel('Radius (μm)', 'FontSize', 11);
    
    % Oxygen heatmap
    axes(ax11);
    imagesc(t_sub, r, data.oxygen);
    set(gca, 'YDir', 'normal');
    colorbar;
    title('Oxygen Level Spatiotemporal Profile', 'FontSize', 12);
    xlabel('Time (hours)', 'FontSize', 11);
    ylabel('Radius (μm)', 'FontSize', 11);
    
    % Damage heatmap
    axes(ax12);
    imagesc(t_sub, r, data.damage);
    set(gca, 'YDir', 'normal');
    colorbar;
    title('Cellular Damage Spatiotemporal Profile', 'FontSize', 12);
    xlabel('Time (hours)', 'FontSize', 11);
    ylabel('Radius (μm)', 'FontSize', 11);
end

% Start the application
advancedTumorGUI();