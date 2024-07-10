%% Plot Formatting Function
function init_plot_settings()
    % Format plot for submission to manuscripts
    set(0, 'DefaultAxesLineWidth', 1.5)
    set(0, 'DefaultLineLineWidth', 1.5)
    set(0, 'DefaultAxesFontSize', 20)
    set(0, 'DefaultAxesFontName', 'Arial')
    set(0, 'DefaultFigureColor', [1 1 1])
    set(0, 'DefaultFigurePosition', [400 250 900 750])
    set(0, 'defaultAxesTickLabelInterpreter','none');
    set(0, 'defaultLegendInterpreter','none');
end