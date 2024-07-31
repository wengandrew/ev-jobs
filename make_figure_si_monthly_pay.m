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