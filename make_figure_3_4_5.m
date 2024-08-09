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

%% Import and organize data for 3 transition plants and U.S. into "EV_data" struct
year_span = 2004:2022;
EV_counties = [6001,17113,26125];

file_AN = 'data/Auto_News/Vehicle_Production_EV_Counties.xlsx';
fips_AN = readmatrix(file_AN,'range','B:B','numheaderlines',1);
veh_all = readmatrix(file_AN,'sheet','veh_all','range','C2');
veh_ICE = readmatrix(file_AN,'sheet','veh_ICE','range','C2');
veh_EV = readmatrix(file_AN,'sheet','veh_EV','range','C2');
pen_EV = readmatrix(file_AN,'sheet','pen_EV','range','C2');

file_QCEW = 'data/QCEW/Employment_EV_Counties.xlsx';
fips_QCEW = readmatrix(file_QCEW,'range','B:B','numheaderlines',1);
emp_3361_QCEW = readmatrix(file_QCEW,'sheet','3361','range','C2');

file_QWI = 'data/QWI/QWI_Employment_EV_Counties.xlsx';
fips_QWI = readmatrix(file_QWI,'range','B:B','numheaderlines',1);
emp_3361_QWI = readmatrix(file_QWI,'sheet','3361','range','C2');

fips_codes = readtable('data/FIPS_Codes.xlsx');
emp_news_xl = readtable('data/News_Reports.xlsx','range','E:G');

EV_data = struct;
for k = 1:length(EV_counties)
    EV_data(k).location = char(fips_codes.area_title(matches(fips_codes.area_fips,sprintf('%05d',EV_counties(k)))));
    EV_data(k).state = floor(EV_couintes(k)/1000)*1000;
    EV_data(k).county = EV_counties(k);
    EV_data(k).veh_all = veh_all(fips_AN==EV_counties(k),:);
    EV_data(k).veh_ICE = veh_ICE(fips_AN==EV_counties(k),:);
    EV_data(k).veh_EV = veh_EV(fips_AN==EV_counties(k),:);
    EV_data(k).pen_EV = pen_EV(fips_AN==EV_counties(k),:);
    veh_mdl = readtable(file_AN,'sheet',['hist_prod_',num2str(EV_counties(k))],'range','A:A');
    veh_type = readmatrix(file_AN,'sheet',['hist_prod_',num2str(EV_counties(k))],'range','B:B','numheaderlines',1);
    veh_prod = readmatrix(file_AN,'sheet',['hist_prod_',num2str(EV_counties(k))],'range','C2'); 
    for j = 1:7
        EV_data(k).hist_prod(j).model = string(veh_mdl.Vehicle(j));
        EV_data(k).hist_prod(j).EV = veh_type(j);
        EV_data(k).hist_prod(j).veh = veh_prod(j,:);
    end
    EV_data(k).emp_3361_QCEW = emp_3361_QCEW(fips_QCEW==EV_counties(k),:);
    EV_data(k).emp_3361_QWI = emp_3361_QWI(fips_QWI==EV_counties(k),:);
    
end
k = k+1;
EV_data(k).location = 'U.S. Total';
EV_data(k).state = 'US000';
EV_data(k).county = 'US000';
EV_data(k).veh_all = veh_all(end,:);
EV_data(k).veh_ICE = veh_ICE(end,:);
EV_data(k).veh_EV = veh_EV(end,:);
EV_data(k).pen_EV = pen_EV(end,:);
file_QCEW = 'data/QCEW/Employment_US.xlsx';
EV_data(k).emp_3361_QCEW = readmatrix(file_QCEW,'sheet','3361','range','C2');
EV_data(k).emp_3361_QWI = nan(size(year_span));
US_wpv = EV_data(end).emp_3361_QCEW./(.001.*EV_data(end).veh_all);

%% [SELECT DESIRED PLANT] Production History for 3 transition plants
% ~~ Uncomment desired plant~~ %
fig_name = 'Alameda';
k = 1;
y_lim = .32;
y_text = .17;

% fig_name = 'McLean';
% k = 2;
% y_lim = .08;
% y_text = .03;

% fig_name = 'Oakland';
% k = 3;
% y_lim = .22;
% y_text = .16;
% ~~ Uncomment desired plant ~~ %

fill_veh_all = [];
figure(1)
clf
t = tiledlayout(7,1,'padding','tight','tilespacing','tight');

for j = 1:7
    ax = nexttile;
    hold on
    
    if EV_data(k).hist_prod(j).EV
        fill([year_span,fliplr(year_span)],[EV_data(k).hist_prod(j).veh,repelem(0,length(year_span))].*1e-6,'r','edgecolor','none','facecolor','#50C878')            
    else
        fill([year_span,fliplr(year_span)],[EV_data(k).hist_prod(j).veh,repelem(0,length(year_span))].*1e-6,'r','edgecolor','none','facecolor',.7*ones(1,3));
    end
    if j == 1
        yline(y_lim,'color',.998*ones(1,3),'linewidth',.01)
    end
    text(median(year_span),y_text,EV_data(k).hist_prod(j).model,'horizontalalignment','center','fontsize',14)
    xticks(2004:6:2022)
    if j ~= 7
        set(gca,'XTickLabel',[])
    end
    set(gca,'YColor','none')
    ylim([0,y_lim])
end
xtickangle(30)
xlabel('Year')
set(gca,'YColor','none')
ylim([0,y_lim])

linkaxes(findall(t,'type','axes'),'x')
ax.XLim = [year_span(1),year_span(end)+1];

t.Units = 'inches';
t.OuterPosition(3:4) = [4 10];
%exportgraphics(t,[fig_name,'_production_history.png'],'resolution',600)

%% Alameda Labor Intensity
fig_name = 'Alameda';
k = 1;
y_lim_1 = 5;
y_lim_2 = 30;
y_lim_3 = 200;
veh = EV_data(k).veh_all;
emp = mean([EV_data(k).emp_3361_QCEW;EV_data(k).emp_3361_QWI],'omitnan');
wpv = emp./(.001.*veh);
year_span_adj = year_span;
wpv_adj = wpv;
year_span_adj(find(veh==0)+(0:1)) = NaN;
wpv_adj(find(veh==0)+(0:1)) = NaN;
year_span_news = emp_news_xl.Year(emp_news_xl.CountyCode==EV_data(k).county)';
emp_news = emp_news_xl.Employees(emp_news_xl.CountyCode==EV_data(k).county)';
[~,i_news]=intersect(year_span,year_span_news);
veh_news = veh(i_news);
wpv_news = emp_news./(.001.*veh_news);

figure()
clf
t = tiledlayout(7,1,'padding','loose','tilespacing','compact');

ax1 = nexttile([2,1]);
hold on
plot(year_span,veh.*1e-5,'color',[110 157 235]./255,'linewidth',3)
set(gca,'XTickLabel',[])
ylabel('Vehicles (100,000s)','units','normalized','position',[-.1,.5])
ylim([0,y_lim_1])
yyaxis right
plot(year_span,EV_data(k).pen_EV,'-.','color','#228B22','linewidth',3)
set(gca,'YColor','#228B22')
ylabel('EV Production %')
xticks(2004:6:2022)
ylim([-5,105])
box on

ax2 = nexttile([2,1]);
hold on
plt_gov = plot(year_span,emp.*1e-3,'color',[110 157 235]./255,'linewidth',3,'display',[fig_name,' (Gov)']);
plt_news = scatter(year_span_news,emp_news.*1e-3,70,'markerfacecolor',[110 157 235]./255,'markeredgecolor',[110 157 235]./255,'display',[fig_name,' (News)']);
legend('show','location','nw','fontsize',12)
set(gca,'XTickLabel',[])
ylabel('Workers (1,000s)','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
ylim([0,y_lim_2])
box on

ax3 = nexttile([3,1]);
hold on
plt_US = plot(year_span,US_wpv,':','color','#7E2F8E','linewidth',3,'display','U.S.');
plt_co = plot(year_span_adj,wpv_adj,'color',[110 157 235]./255,'linewidth',3,'display',[fig_name,' (Gov)']);
plt_news = scatter(year_span_news,wpv_news,70,'markerfacecolor',[110 157 235]./255,'markeredgecolor',[110 157 235]./255,'display',[fig_name,' (News)']);    
legend('show','location','nw','fontsize',12)
xlabel('Year')
ylabel('Workers per 1,000 Vehicles','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
xtickangle(30)
ylim([0,y_lim_3])
box on

linkaxes(findall(t,'type','axes'),'x')
ax1.XLim = [year_span(1),year_span(end)+1];

t.Units = 'inches';
t.OuterPosition(3:4) = [6 10];
%exportgraphics(t,[fig_name,'_labor_intensity.png'],'resolution',600)

% Format and write output source data files
data_table_prod = table(year_span', veh', 'VariableNames', {'Year', 'Production'});
data_table_emp_gov = table(year_span', emp', wpv_adj', US_wpv', 'VariableNames', {'Year', 'Employment (Gov)', 'WPV (Gov)', 'WPV (US)'});
data_table_emp_news = table(year_span_news', emp_news', wpv_news', 'VariableNames', {'Year', 'Employment (News)', 'WPV (News)'});
writetable(data_table_prod, 'source_fig3_alameda_production.csv')
writetable(data_table_emp_gov, 'source_fig3_alameda_employment_wpv_govt.csv')
writetable(data_table_emp_news, 'source_fig3_alameda_employmnet_wpv_news.csv')


%% Oakland Labor Intensity
fig_name = 'Oakland';
k = 3;
y_lim_1 = 5;
y_lim_2 = 20;
y_lim_3 = 50;
veh = EV_data(k).veh_all;
emp = mean([EV_data(k).emp_3361_QCEW;EV_data(k).emp_3361_QWI],'omitnan');
wpv = emp./(.001.*veh);
year_span_adj = year_span;
wpv_adj = wpv;
year_span_adj(find(veh==0)+(0:1)) = NaN;
wpv_adj(find(veh==0)+(0:1)) = NaN;
year_span_news = emp_news_xl.Year(emp_news_xl.CountyCode==EV_data(k).county)';
emp_news = emp_news_xl.Employees(emp_news_xl.CountyCode==EV_data(k).county)';
[~,i_news]=intersect(year_span,year_span_news);
veh_news = veh(i_news);
wpv_news = emp_news./(.001.*veh_news);

figure()
clf
t = tiledlayout(7,1,'padding','loose','tilespacing','compact');

ax1 = nexttile([2,1]);
hold on
plot(year_span,veh.*1e-5,'color',[110 157 235]./255,'linewidth',3)
set(gca,'XTickLabel',[])
ylabel('Vehicles (100,000s)','units','normalized','position',[-.1,.5])
ylim([0,y_lim_1])
yyaxis right
plot(year_span,EV_data(k).pen_EV,'-.','color','#228B22','linewidth',3)
set(gca,'YColor','#228B22')
ylabel('EV Production %')
xticks(2004:6:2022)
ylim([-5,105])
box on

ax2 = nexttile([2,1]);
hold on
plt_gov = plot(year_span,emp.*1e-3,'color',[110 157 235]./255,'linewidth',3,'display',[fig_name,' (Gov)']);
set(gca,'XTickLabel',[])
ylabel('Workers (1,000s)','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
ylim([0,y_lim_2])
box on

ax3 = nexttile([3,1]);
hold on
plt_US = plot(year_span,US_wpv,':','color','#7E2F8E','linewidth',3,'display','U.S.');
%plt_co_out = plot(year_span,wpv,'-.','color',.5*ones(1,3),'linewidth',2,'display','Alameda (QWI)');
plt_co = plot(year_span_adj,wpv_adj,'color',[110 157 235]./255,'linewidth',3,'display',[fig_name,' (Gov)']);
legend('show','location','nw','fontsize',12)
xlabel('Year')
ylabel('Workers per 1,000 Vehicles','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
xtickangle(30)
ylim([0,y_lim_3])
box on

linkaxes(findall(t,'type','axes'),'x')
ax1.XLim = [year_span(1),year_span(end)+1];

t.Units = 'inches';
t.OuterPosition(3:4) = [6 10];
%exportgraphics(t,[fig_name,'_labor_intensity.png'],'resolution',600)

% Format and write output source data files
data_table_prod = table(year_span', veh', 'VariableNames', {'Year', 'Production'});
data_table_emp_gov = table(year_span', emp', wpv_adj', US_wpv', 'VariableNames', {'Year', 'Employment (Gov)', 'WPV (Gov)', 'WPV (US)'});
writetable(data_table_prod, 'source_fig4_oakland_production.csv')
writetable(data_table_emp_gov, 'source_fig4_oakland_employment_wpv_govt.csv')

%% McLean Labor Intensity
fig_name = 'McLean';
k = 2;
y_lim_1 = 1.5;
y_lim_2 = 6;
y_lim_3 = 330;
veh = EV_data(k).veh_all;
year_span_news = emp_news_xl.Year(emp_news_xl.CountyCode==EV_data(k).county)';
emp_news = emp_news_xl.Employees(emp_news_xl.CountyCode==EV_data(k).county)';
[~,i_news]=intersect(year_span,year_span_news);
veh_news = veh(i_news);
wpv_news = emp_news./(.001.*veh_news);

figure()
clf
t = tiledlayout(7,1,'padding','loose','tilespacing','compact');

ax1 = nexttile([2,1]);
hold on
plot(year_span,veh.*1e-5,'color',[110 157 235]./255,'linewidth',3)
set(gca,'XTickLabel',[])
ylabel('Vehicles (100,000s)','units','normalized','position',[-.1,.5])
ylim([0,y_lim_1])
yyaxis right
plot(year_span,EV_data(k).pen_EV,'-.','color','#228B22','linewidth',3)
set(gca,'YColor','#228B22')
ylabel('EV Production %')
xticks(2004:6:2022)
ylim([-5,105])
box on

ax2 = nexttile([2,1]);
hold on
plt_news = scatter(year_span_news,emp_news.*1e-3,70,'markerfacecolor',[110 157 235]./255,'markeredgecolor',[110 157 235]./255,'display',[fig_name,' (News)']);
set(gca,'XTickLabel',[])
ylabel('Workers (1,000s)','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
ylim([0,y_lim_2])
box on

ax3 = nexttile([3,1]);
hold on
plt_US = plot(year_span,US_wpv,':','color','#7E2F8E','linewidth',3,'display','U.S.');
plt_news = scatter(year_span_news,wpv_news,70,'markerfacecolor',[110 157 235]./255,'markeredgecolor',[110 157 235]./255,'display',[fig_name,' (News)']);    
legend('show','location','nw','fontsize',12)
xlabel('Year')
ylabel('Workers per 1,000 Vehicles','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
xtickangle(30)
ylim([0,y_lim_3])
box on

linkaxes(findall(t,'type','axes'),'x')
ax1.XLim = [year_span(1),year_span(end)+1];

t.Units = 'inches';
t.OuterPosition(3:4) = [6 10];
%exportgraphics(t,[fig_name,'_labor_intensity.png'],'resolution',600)

% Format and write output source data files
data_table_prod = table(year_span', veh', 'VariableNames', {'Year', 'Production'});
data_table_emp_news = table(year_span_news', emp_news', wpv_news', 'VariableNames', {'Year', 'Employment (News)', 'WPV (News)'});
writetable(data_table_prod, 'source_fig5_mclean_production.csv')
writetable(data_table_emp_news, 'source_fig5_mclean_employment_wpv_news.csv')

%% U.S. Labor Intensity
fig_name = 'US';
y_lim_1 = 15;
y_lim_2 = 3;
y_lim_3 = 40;

veh = EV_data(end).veh_all;
emp = mean([EV_data(end).emp_3361_QCEW;EV_data(end).emp_3361_QWI],'omitnan');
wpv = emp./(.001.*veh);

figure()
clf
t = tiledlayout(7,1,'padding','loose','tilespacing','compact');

ax1 = nexttile([2,1]);
hold on
plot(year_span,veh.*1e-6,':','color','#7E2F8E','linewidth',3)
set(gca,'XTickLabel',[])
ylabel('Vehicles (Millions)','units','normalized','position',[-.1,.5])
ylim([0,y_lim_1])
yyaxis right
plot(year_span,EV_data(end).pen_EV,'-.','color','#228B22','linewidth',3)
set(gca,'YColor','#228B22')
ylabel('EV Production %')
xticks(2004:6:2022)
ylim([-.5,10])
box on

ax2 = nexttile([2,1]);
hold on
plt_gov = plot(year_span,emp.*1e-5,':','color','#7E2F8E','linewidth',3,'display',[fig_name,' (Gov)']);
set(gca,'XTickLabel',[])
ylabel('Workers (100,000s)','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
ylim([1,y_lim_2])
box on

ax3 = nexttile([3,1]);
hold on
plt_co_out = plot(year_span,wpv,':','color','#7E2F8E','linewidth',3,'display','Alameda (QWI)');
xlabel('Year')
ylabel('Workers per 1,000 Vehicles','units','normalized','position',[-.1,.5])
xticks(2004:6:2022)
xtickangle(30)
ylim([0,y_lim_3])
box on

linkaxes(findall(t,'type','axes'),'x')
ax1.XLim = [year_span(1),year_span(end)+1];

t.Units = 'inches';
t.OuterPosition(3:4) = [6 10];
%exportgraphics(t,[fig_name,'_labor_intensity.png'],'resolution',600)
