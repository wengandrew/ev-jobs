function make_simulation()
% Develop a forecast of future labor intensity based on Alameda's data vs
% national trends. The metric to focus on is WPV: workers per vehicle per
% annum.

clear all; close all; clc

init_plot_settings()

%% Load the Alameda WPV data from Govt
tbl = readtable("data/WPV_Summary_Alameda_vs_National.xlsx");

years = tbl.Year;
ev_wpv = tbl.WPV_Alameda;

ev_lim_wpv = ev_wpv((years >= 2014));
ev_lim_years = years((years >= 2014));

%% Load the Baseline data

years = tbl.Year;
base_wpv = tbl.WPV_National;

base_lim_wpv = base_wpv(years <= 2015);
base_lim_years = years(years <= 2015);

base_years_projected = [2015:1:2040];
base_projected = base_lim_wpv(end)*ones(1,numel(base_years_projected));

ev_years_projected = [2010:0.1:2040];

ft = fittype('a/(1+exp(-b*(x-c)))+16.8977*0.7',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'});

f = fit([ev_lim_years], [ev_lim_wpv], ...
    ft, 'StartPoint', [2000,-0.2,2000]);

%% Make the figure
figure(); box on

% Monte Carlo sampling projections
for i = 1:1000

    a = normrnd( 448.2 , 448.2*0.10 );
    b = -normrnd( 0.2791 , 0.2791*0.10 );
    c = 2012;
    d = normrnd( 16.8977*0.7 , 16.8977*0.7*0.30 );
    ff = @(x) a./(1+exp(-b.*(x-c)))+d;
    line(ev_years_projected-2010, ff(ev_years_projected), 'LineWidth', 1, 'Color', [0.4, 0.8, 0.4, 0.05], 'HandleVisibility', 'off')

end

line(base_years_projected-2010, base_projected, 'LineWidth', 1.5, 'Color', '#0b389d', 'LineStyle', '--', 'HandleVisibility', 'off')
line(ev_years_projected-2010, f(ev_years_projected), 'LineWidth', 1.5, 'Color', '#3c821f', 'LineStyle', '--', 'HandleVisibility', 'off')

line(years-2010, ev_wpv, 'Color', '#3c821f', 'LineWidth', 1.0, 'LineStyle', '-', 'HandleVisibility', 'off')
line(nan, nan, 'Color', '#3c821f', 'LineWidth', 1.5, 'LineStyle', '-', 'DisplayName', 'BEV (Alameda, Govt)', 'Marker', 'o', 'MarkerFaceColor', '#3c821f')
line(ev_lim_years-2010, ev_lim_wpv, 'Color', '#3c821f', 'LineWidth', 1.5, 'LineStyle', 'none', 'HandleVisibility', 'off', 'Marker', 'o', 'MarkerFaceColor', '#3c821f')
line(years-2010, base_wpv, 'Color', '#0b389d', 'LineWidth', 1.0, 'LineStyle', '-', 'HandleVisibility', 'off')
line(base_lim_years-2010, base_lim_wpv, 'Color', '#0b389d', 'LineWidth', 1.5, 'LineStyle', 'none', 'DisplayName', 'Baseline (U.S. Average)', 'Marker', 'o', 'MarkerFaceColor', '#0b389d')

xlabel({'Years from BEV Factory Open'})
ylabel('Labor Intensity (WPV)')
legend show

ylim([0, 180])
xlim([0, 25])

end