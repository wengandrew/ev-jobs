%{

Data Organization and Figure Making Code for

"30% fewer workers for electric vehicle assembly": harbinger or myth? 

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

