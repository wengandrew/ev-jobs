%{

Data Organization and Figure Making Code for

"Higher labor intensity in US automotive assembly plants after transitioning to electric vehicles"

Authors: Andrew Weng, Omar Y. Ahmed, Gabriel Ehrlich, Anna Stefanopoulou

Department of Mechanical Engineering
Department of Economics
University of Michigan

Data Correspondence: asweng@umich.edu, oyahmed@umich.edu

%}

%% Clear all and set default plot settings
clc
clear variables
close all
init_plot_settings()

%% Load Data on U.S. Auto Manufacturing Workers
file_QCEW = 'data/QCEW/Employment_US.xlsx';
year_span = readmatrix(file_QCEW,'range','C1');
year_span = year_span(1,:);
emp_1013 = readmatrix(file_QCEW,'sheet','1013','range','C2');
emp_3361 = readmatrix(file_QCEW,'sheet','3361','range','C2');
emp_3363 = readmatrix(file_QCEW,'sheet','3363','range','C2');
emp_33631 = readmatrix(file_QCEW,'sheet','33631','range','C2');
emp_33632 = readmatrix(file_QCEW,'sheet','33632','range','C2');
emp_33633 = readmatrix(file_QCEW,'sheet','33633','range','C2');
emp_33634 = readmatrix(file_QCEW,'sheet','33634','range','C2');
emp_33635 = readmatrix(file_QCEW,'sheet','33635','range','C2');
emp_33636 = readmatrix(file_QCEW,'sheet','33636','range','C2');
emp_33637 = readmatrix(file_QCEW,'sheet','33637','range','C2');
emp_33639 = readmatrix(file_QCEW,'sheet','33639','range','C2');

figure()

t = tiledlayout(1,1,'padding','tight','tilespacing','compact');

%% Build primary Y-axis
ax1 = nexttile;
hold on
fill([year_span,fliplr(year_span)],[emp_3363,fliplr(emp_3363+emp_3361)]*1e-6,'b','facecolor',[110 157 235]./255,'edgecolor','black','display','Assembly (NAICS 3361)')
fill([year_span,fliplr(year_span)],[emp_3363-emp_33635,fliplr(emp_3363)]*1e-6,'b','facecolor',[137 137 137]./255,'edgecolor','black','display','Powertrain (NAICS 33635)')
fill([year_span,fliplr(year_span)],[emp_3363-emp_33631-emp_33635,fliplr(emp_3363-emp_33635)]*1e-6,'b','facecolor',[183 183 183]./255,'edgecolor','black','display','Engine (NAICS 33631)')
fill([year_span,fliplr(year_span)],[repelem(0,length(year_span)),fliplr(emp_3363-emp_33631-emp_33635)]*1e-6,'b','facecolor',[204 204 204]./255,'edgecolor','black','display','Other Parts (NAICS 3363x)')

text(mean(year_span),.6,'Assembly','HorizontalAlignment','center','fontsize',16)
text(mean(year_span),.465,'Powertrain Parts','HorizontalAlignment','center','fontsize',16,'Rotation',22)
text(mean(year_span),.41,'Engine Parts','HorizontalAlignment','center','fontsize',16,'Rotation',22)
text(mean(year_span),.2,'Other Parts','HorizontalAlignment','center','fontsize',16)
xlabel('Year')
ylabel('U.S. Auto Manufacturing Workers (Millions)')
xlim([year_span(1),year_span(end)])
xticks(2004:6:2022)
ylim([0,1])

%% Secondary Y-axis
yyaxis right
plot(year_span, emp_1013*1e-6, 'linestyle', '-.','color', .5*ones(1,3), 'linewidth',2,'display','All Manufacturing Workers (Right Axis)')

text(2019.5,13,'$\longrightarrow$','color',.5*ones(1,3),'fontsize',28,'interpreter','latex')
set(gca,'YColor',.5*ones(1,3))
ylabel('All U.S. Manufacturing Workers (Millions)')
ylim([0,15])
box on
t.Units = 'inches';
t.OuterPosition(3:4) = [8 7];
%exportgraphics(t,'US_auto_manuf_workers.png','resolution',600)

%% Export to source data file
data_table = table(year_span', ...
                   [emp_3363+emp_3361]', ...
                   [emp_3363]', ...
                   [emp_3363-emp_33635]', ...
                   [emp_3363-emp_33631-emp_33635]', ...
                   emp_1013', ...
                   'VariableNames', {'Year Vector', 'Assembly (NAICS 3361)', 'Powertrain (NAICS 33635)', ...
                   'Engine (NAICS 33631)', 'Other Parts (NAICS 3363x)', 'All Manufacturing Workers'});


writetable(data_table, 'source_fig1_employment.csv')