%{

Data Organization and Figure Making Code for

"30% fewer workers for electric vehicle assembly": harbinger or myth? in Nature Communications
Authors: Andrew Weng, Omar Y. Ahmed, Gabriel Ehrlich, Anna Stefanopoulou

Department of Mechanical Engineering
Department of Economics
University of Michigan

Data Correspondence: asweng@umich.edu, oyahmed@umich.edu

Requires:
Matlab Mapping Toolbox

%}

%% Clear all and set default plot settings
clc
clear variables
close all
init_plot_settings()

%% U.S. Auto Manufacturing Workers
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
clf
t = tiledlayout(1,1,'padding','tight','tilespacing','compact');

ax1 = nexttile;
hold on
fill([year_span,fliplr(year_span)],[emp_3363,fliplr(emp_3363+emp_3361)]*1e-6,'b','facecolor',[110 157 235]./255,'edgecolor','black','display','Assembly (NAICS 3361)')
fill([year_span,fliplr(year_span)],[emp_3363-emp_33635,fliplr(emp_3363)]*1e-6,'b','facecolor',[137 137 137]./255,'edgecolor','black','display','Powertrain (NAICS 33635)')
fill([year_span,fliplr(year_span)],[emp_3363-emp_33631-emp_33635,fliplr(emp_3363-emp_33635)]*1e-6,'b','facecolor',[183 183 183]./255,'edgecolor','black','display','Engine (NAICS 33631)')
fill([year_span,fliplr(year_span)],[repelem(0,length(year_span)),fliplr(emp_3363-emp_33631-emp_33635)]*1e-6,'b','facecolor',[204 204 204]./255,'edgecolor','black','display','Other Parts (NAICS 3363x)')
text(mean(year_span),.6,'Assembly','HorizontalAlignment','center','fontsize',16)
text(mean(year_span),.465,'Powertrain Parts','HorizontalAlignment','center','fontsize',16,'Rotation',22)
text(mean(year_span),.41,'Engine Parts','HorizontalAlignment','center','fontsize',16,'Rotation',22)
% text(mean(year_span),.2,['Other Parts: Electrical, Suspension, Steering,',newline,'Brakes, Seating, Trim, and Metal Stamping'],'HorizontalAlignment','center','fontsize',16)
text(mean(year_span),.2,'Other Parts','HorizontalAlignment','center','fontsize',16)
xlabel('Year')
ylabel('U.S. Auto Manufacturing Workers (Millions)')
xlim([year_span(1),year_span(end)])
xticks(2004:6:2022)
ylim([0,1])
yyaxis right
plot(year_span,emp_1013*1e-6,'linestyle','-.','color',.5*ones(1,3),'linewidth',2,'display','All Manufacturing Workers (Right Axis)')
% text(2009,13.6,'\it{All U.S. Manufacturing}','color',.5*ones(1,3),'fontsize',16)
text(2019.5,13,'$\longrightarrow$','color',.5*ones(1,3),'fontsize',28,'interpreter','latex')
set(gca,'YColor',.5*ones(1,3))
ylabel('All U.S. Manufacturing Workers (Millions)')
ylim([0,15])
box on
t.Units = 'inches';
t.OuterPosition(3:4) = [8 7];
%exportgraphics(t,'US_auto_manuf_workers.png','resolution',600)


%% U.S. Map with Jobs and Assembly Locations
file_QCEW = 'data/QCEW/Employment_State.xlsx';
year_span = readmatrix(file_QCEW,'range','C1');
year_span = year_span(1,:);
emp_3361 = readmatrix(file_QCEW,'sheet','3361','range','C2');
emp_year = emp_3361(:,year_span==2022).*1e-3;
emp_year(isnan(emp_year)) = -1;
state_names = readtable(file_QCEW,'Range','A:A');
state_names = string(state_names.Area);
for j = 1:length(state_names)
    if endsWith(state_names(j),' -- Statewide')
        new_name = char(state_names(j));
        state_names(j) = new_name(1:end-13);
    end
end
states = readgeotable("usastatelo.shp");
state_emp = table(state_names,emp_year,'variablenames',{'State','Employees'});
x = outerjoin(states,state_emp,"LeftKey","Name","RightKey","State");
rows = x.Name ~= "Hawaii" & x.Name ~= "Alaska";
y = x(rows,:);
car_plants = readtable('data/Car_Plants_2022.xlsx','range','A:D');
car_plants.EV(isnan(car_plants.EV)) = 0;

figure()
clf
t = tiledlayout(1,1,'padding','tight');

ax1 = nexttile;
geoplot(y,ColorVariable="Employees");
hold on
loc_ICE = geoplot(car_plants.Latitude(car_plants.EV==0),car_plants.Longitude(car_plants.EV==0),'o','MarkerFaceColor',.7*ones(1,3),'MarkerEdgeColor','black','linewidth',.5,'display','ICEV Plant');
%loc_mix = geoplot(car_plants.Latitude(car_plants.EV==1),car_plants.Longitude(car_plants.EV==1),'o','MarkerFaceColor','#0072BD','MarkerEdgeColor','black','display','ICEV \& EV Plant');
loc_EV = geoplot(car_plants.Latitude(car_plants.EV==2),car_plants.Longitude(car_plants.EV==2),'o','MarkerFaceColor','#50C878','MarkerEdgeColor','black','linewidth',.5,'display','EV Plant');
loc_trans = geoplot(car_plants.Latitude(car_plants.EV==3),car_plants.Longitude(car_plants.EV==3),'p','MarkerFaceColor','#50C878','MarkerEdgeColor','black','linewidth',.5,'display','Transition Plant (ICEV to EV)','markersize',15);
coord_a = [31,-122];
geoplot([coord_a(1),car_plants.Latitude(47)],[coord_a(2),car_plants.Longitude(47)],'black')
text(coord_a(1),coord_a(2),'Alameda','HorizontalAlignment','center','backgroundcolor','white','margin',1)
coord_b = [48,-77];
geoplot([coord_b(1),car_plants.Latitude(29)],[coord_b(2),car_plants.Longitude(29)],'black')
text(coord_b(1),coord_b(2),'Oakland','HorizontalAlignment','center','backgroundcolor','white','margin',1)
coord_c = [50,-90];
geoplot([coord_c(1),car_plants.Latitude(44)],[coord_c(2),car_plants.Longitude(44)],'black')
text(coord_c(1),coord_c(2),'McLean','HorizontalAlignment','center','backgroundcolor','white','margin',1)
legend([loc_ICE,loc_EV,loc_trans],'location','n','orientation','horizontal')
cmap = interp1(linspace(0,1,6),[252, 251, 249;215, 220, 234;161, 179, 215;101, 129, 191;47, 87, 171;11, 56, 157]./255,linspace(0,1,100)); %blue
colormap([.5*ones(1,3);cmap]);
cb = colorbar;
cb.Label.String = "Auto Assembly Workers (1,000s)";
cb.Location = 'south';
cb.Limits = [0,45];
cb.FontSize = 10;
gx = gca;
gx.Basemap = 'none';
gx.Grid = 'off';
gx.LatitudeAxis.Visible = 'off';
gx.LongitudeAxis.Visible = 'off';
gx.Scalebar.Visible = "off";
geolimits([15.3977   54.3065],[-126.1638  -65.5263])

t.Units = 'inches';
t.OuterPosition(3:4) = [5 4];
% exportgraphics(t,'US_auto_manuf_map.png','resolution',600)

%% Import and organize data for 3 transition plants and U.S. into "EV_data" struct
year_span = 2004:2022;
AN_dir = 'data/Auto_News';
EV_counties = [];
for i = 1:length(year_span)
    county_code = readmatrix([AN_dir,'/Production_',num2str(year_span(i)),'.xlsx'],'range','G:G','numheaderlines',1);
    EV_code = readmatrix([AN_dir,'/Production_',num2str(year_span(i)),'.xlsx'],'range','H:H','numheaderlines',1);
    EV_counties = [EV_counties;county_code((county_code==6001 | county_code==26125 | county_code==17113) & EV_code==1)];
end
EV_counties = unique(EV_counties);

file_QCEW = 'data/QCEW/Employment_EV_Counties.xlsx';
fips_QCEW = readmatrix(file_QCEW,'range','B:B','numheaderlines',1);
emp_3361_QCEW = readmatrix(file_QCEW,'sheet','3361','range','C2');
emp_3363_QCEW = readmatrix(file_QCEW,'sheet','3363','range','C2');

file_QWI = 'data/QWI/QWI_Employment_EV_Counties.xlsx';
fips_QWI = readmatrix(file_QWI,'range','B:B','numheaderlines',1);
emp_3361_QWI = readmatrix(file_QWI,'sheet','3361','range','C2');

fips_codes = readtable('data/FIPS_Codes.xlsx');
emp_news_xl = readtable('data/News_Reports.xlsx','range','E:G');

EV_data = struct;
for k = 1:length(EV_counties)
    EV_data(k).location = char(fips_codes.area_title(matches(fips_codes.area_fips,sprintf('%05d',EV_counties(k)))));
    EV_data(k).state = floor(EV_counties(k)/1000)*1000;
    EV_data(k).county = EV_counties(k);
    roster_models = [];
    roster_years = [];
    roster_veh = [];
    roster_EV = [];
    veh_all = zeros(1,length(year_span));
    veh_ICE = zeros(1,length(year_span));
    veh_EV = zeros(1,length(year_span));
    num_models = zeros(1,length(year_span));
    for i = 1:length(year_span)
        AN_data = readtable([AN_dir,'/Production_',num2str(year_span(i)),'.xlsx'],'range','A:H');
        roster_models = [roster_models;strcat(AN_data.Automaker(AN_data.County==EV_counties(k) & AN_data.Production > 0)," - ",AN_data.Model(AN_data.County==EV_counties(k) & AN_data.Production > 0)," in ",AN_data.Location(AN_data.County==EV_counties(k) & AN_data.Production > 0))];
        roster_years = [roster_years;repelem(year_span(i),length(AN_data.Model(AN_data.County==EV_counties(k) & AN_data.Production > 0)))'];
        roster_veh = [roster_veh;AN_data.Production(AN_data.County==EV_counties(k) & AN_data.Production > 0)];
        roster_EV = [roster_EV;AN_data.EV(AN_data.County==EV_counties(k) & AN_data.Production > 0)];
        models = string(unique(AN_data.Model(AN_data.County==EV_counties(k) & AN_data.Production > 0)));
        num_models(i) = length(models);
        veh_all(i) = sum(AN_data.Production(AN_data.County==EV_counties(k)));
        veh_ICE(i) = sum(AN_data.Production(AN_data.County==EV_counties(k) & AN_data.EV==0));
        veh_EV(i) = sum(AN_data.Production(AN_data.County==EV_counties(k) & AN_data.EV==1));
    end
    roster_unique = unique(roster_models);
    hist_prod = struct;
    for j = 1:length(roster_unique)
        hist_prod(j).model = roster_unique(j);
        hist_prod(j).EV = mean(roster_EV(roster_models==roster_unique(j)));
        hist_prod(j).years = roster_years(roster_models==roster_unique(j))';
        hist_prod(j).veh = roster_veh(roster_models==roster_unique(j))';
        hist_prod(j).total_veh = sum(hist_prod(j).veh);
    end
    EV_data(k).hist_prod = hist_prod;
    if ~isequal(veh_all,veh_ICE+veh_EV)
        disp('Discrepancy detected')
    end
    pen_EV = veh_EV./veh_all.*100;
    pen_EV(isnan(pen_EV))=0;
    EV_data(k).veh_all = veh_all;
    EV_data(k).veh_ICE = veh_ICE;
    EV_data(k).veh_EV = veh_EV;
    EV_data(k).pen_EV = pen_EV;
    EV_data(k).num_models = num_models;
    EV_data(k).emp_3361_QCEW = emp_3361_QCEW(fips_QCEW==EV_counties(k),:);
    EV_data(k).emp_3361_QWI = emp_3361_QWI(fips_QWI==EV_counties(k),:);
    EV_data(k).emp_3363_QCEW = emp_3363_QCEW(fips_QCEW==EV_counties(k),:);
    
end
k = k+1;
EV_data(k).location = 'U.S. Total';
EV_data(k).state = 'US000';
EV_data(k).county = 'US000';
veh_all = zeros(1,length(year_span));
veh_ICE = zeros(1,length(year_span));
veh_EV = zeros(1,length(year_span));
num_models = zeros(1,length(year_span));
for i = 1:length(year_span)
    AN_data = readtable([AN_dir,'/Production_',num2str(year_span(i)),'.xlsx'],'range','A:H');
    veh_all(i) = sum(AN_data.Production(AN_data.County~=0));
    veh_ICE(i) = sum(AN_data.Production(AN_data.County~=0 & AN_data.EV==0));
    veh_EV(i) = sum(AN_data.Production(AN_data.County~=0 & AN_data.EV==1));
    models = string(unique(AN_data.Model(AN_data.County~=0 & AN_data.Production > 0)));
    num_models(i) = length(models);
end
if ~isequal(veh_all,veh_ICE+veh_EV)
    disp('Discrepancy detected')
end
pen_EV = veh_EV./veh_all.*100;
pen_EV(isnan(pen_EV))=0;
EV_data(k).veh_all = veh_all;
EV_data(k).veh_ICE = veh_ICE;
EV_data(k).veh_EV = veh_EV;
EV_data(k).pen_EV = pen_EV;
EV_data(k).num_models = num_models;
file_QCEW = 'data/QCEW/Employment_US.xlsx';
EV_data(k).emp_3361_QCEW = readmatrix(file_QCEW,'sheet','3361','range','C2');
EV_data(k).emp_3361_QWI = nan(size(year_span));
EV_data(k).emp_3363_QCEW = readmatrix(file_QCEW,'sheet','3363','range','C2');
US_wpv = EV_data(end).emp_3361_QCEW./(.001.*EV_data(end).veh_all);

k = 1;
EV_data(k).hist_prod(1).text = "Pontiac Vibe";
EV_data(k).hist_prod(2).text = "Tesla Model 3";
EV_data(k).hist_prod(3).text = "Tesla Model S";
EV_data(k).hist_prod(4).text = "Tesla Model X";
EV_data(k).hist_prod(5).text = "Tesla Model Y";
EV_data(k).hist_prod(6).text = "Toyota Corolla";
EV_data(k).hist_prod(7).text = "Toyota Tacoma";
EV_data(k).hist_prod(8).text = "Toyota Voltz";

k = 2;
EV_data(k).hist_prod(1).text = "Chrysler Sebring";
EV_data(k).hist_prod(2).text = "Chrysler Stratus";
EV_data(k).hist_prod(3).text = "Mitsubishi Eclipse (convertible)";
EV_data(k).hist_prod(4).text = "Mitsubishi Eclipse";
EV_data(k).hist_prod(5).text = "Mitsubishi Endeavor";
EV_data(k).hist_prod(6).text = "Mitsubishi Galant";
EV_data(k).hist_prod(7).text = "Mitsubishi Outlander";
EV_data(k).hist_prod(8).text = "Rivian R1S";
EV_data(k).hist_prod(9).text = "Rivian R1T";

k = 3;
EV_data(k).hist_prod(1).text = "Ford GT (Wixom Plant)";
EV_data(k).hist_prod(2).text = "Lincoln LS (Wixom Plant)";
EV_data(k).hist_prod(3).text = "Ford Thunderbird (Wixom Plant)";
EV_data(k).hist_prod(4).text = "Lincoln Town Car (Wixom Plant)";
EV_data(k).hist_prod(5).text = "Chevy Bolt";
EV_data(k).hist_prod(6).text = "Pontiac G6";
EV_data(k).hist_prod(7).text = "Buick LeSabre";
EV_data(k).hist_prod(8).text = "Chevy Malibu";
EV_data(k).hist_prod(9).text = "Buick Park Avenue";
EV_data(k).hist_prod(10).text = "GMC Sierra (Pontiac Plant)";
EV_data(k).hist_prod(11).text = "Chevy Silverado (Pontiac Plant)";
EV_data(k).hist_prod(12).text = "Chevy Sonic";
EV_data(k).hist_prod(13).text = "Buick Verano";

%% [SELECT DESIRED PLANT] Production History for 3 transition plants
% ~~ Uncomment desired plant~~ %

% fig_name = 'Alameda';
% k = 1;
% j_select = [5,2,4,3,6,7];
% y_lim = .32;
% y_text = .17;

% fig_name = 'Oakland';
% k = 3;
% j_select = [5,12,13,8,6,11];
% y_lim = .22;
% y_text = .16;

fig_name = 'McLean';
k = 2;
j_select = [9,8,7,6,4,5];
y_lim = .08;
y_text = .03;

% ~~ Uncomment desired plant ~~ %

figure()
clf
t = tiledlayout(length(j_select)+1,1,'padding','tight','tilespacing','tight');

for j = j_select
    ax = nexttile;
    hold on
    fill_veh = zeros(size(year_span));
    [~,i_years] = intersect(year_span,EV_data(k).hist_prod(j).years);
    fill_veh(i_years) = EV_data(k).hist_prod(j).veh;
    if EV_data(k).hist_prod(j).EV
        fill([year_span,fliplr(year_span)],[fill_veh,repelem(0,length(year_span))].*1e-6,'r','edgecolor','none','facecolor','#50C878')            
    else
        fill([year_span,fliplr(year_span)],[fill_veh,repelem(0,length(year_span))].*1e-6,'r','edgecolor','none','facecolor',.7*ones(1,3));
    end
    if j == j_select(1)
        yline(y_lim,'color',.998*ones(1,3),'linewidth',.01)
    end
    text(median(year_span),y_text,EV_data(k).hist_prod(j).text,'horizontalalignment','center','fontsize',14)
    xticks(2004:6:2022)
    set(gca,'XTickLabel',[])
    set(gca,'YColor','none')
    ylim([0,y_lim])
end
nexttile;
hold on
fill_veh_others = zeros(size(year_span));
for j = setxor(1:length(EV_data(k).hist_prod),j_select)
    fill_veh = zeros(size(year_span));
    [~,i_years] = intersect(year_span,EV_data(k).hist_prod(j).years);
    fill_veh(i_years) = EV_data(k).hist_prod(j).veh;
    fill_veh_others = fill_veh_others+fill_veh;
end
fill([year_span,fliplr(year_span)],[fill_veh_others,repelem(0,length(year_span))].*1e-6,'r','edgecolor','none','facecolor',.7*ones(1,3));
text(median(year_span),y_text,'Other Models','horizontalalignment','center','fontsize',14)
xticks(2004:6:2022)
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

%% Monthly Pay of Assembly Workers in Alameda and Oakland
pay_oak = readmatrix('data/QWI/Pay_Oakland_3361_Quarterly.xlsx','range','B:B','numheaderlines',1);
pay_ala = readmatrix('data/QWI/Pay_Alameda_3361_Quarterly.xlsx','range','B:B','numheaderlines',1);

figure()
clf
t = tiledlayout(1,1,'padding','compact');
ax1 = nexttile;
hold on
plot(2004:.25:2022.75,pay_ala*1e-3,'linewidth',2,'display','Alameda, CA');
plot(2004:.25:2021.75,pay_oak*1e-3,'linewidth',2,'display','Oakland, MI');
legend('show','location','nw')
ylabel('Assembly Worker Monthly Pay ($k)')
xlim([2004,2023])
ylim([5,21])
xticks(2004:6:2023)
box on
t.Units = 'inches';
t.OuterPosition(3:4) = [6 5.5];
%exportgraphics(t,'Monthly_Pay_Alameda_Oakland.png','resolution',600)