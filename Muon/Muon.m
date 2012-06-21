%%  Muon2.m
%Muon Analysis Program.
%filename = input('Please instert the EXACT path name of the file... \n', 's')
%fprintf('importing file \n');

%% Section 1 Load Data
% Variables
clear
clc
bins = 60 %you can adjust # of bins here
%Uncommit to specify bins
% bins = input('What bins # it? \n');
% trial = input('What trial # it? \n');

%Section 1: Importing Data

Raw1 = importdata('\Data\12-06-05-14-52-12-06-07-13-52-00.data',' ');
Raw2 = importdata('\Data\12-06-07-14-10.data',' ');
Raw3 = importdata('\Data\12-06-12-14-09.data',' ');
Raw4 = importdata('\Data\12-06-14-13-58.data',' ');%Replace line here
%%you need to locate the file and change this ^^^^ to the right location
%Every number less than 40,000 is the time measured in nanoseconds,
%%between successive signals and, background aside, identifies a muon decay.
fprintf('converting data \n')
muon1 = Raw1(find(Raw1(:,1) < 40000),:); %cell iteration in this step is 
%intentional as the file size of .data makes up varies. This on stips the
%invalid points
muon2 = Raw2(find(Raw2(:,1) < 40000),:);
muon3 = Raw3(find(Raw3(:,1) < 40000),:);
muon4 = Raw4(find(Raw4(:,1) < 40000),:);
muon1(:,1) = 10.^(-3).*muon1(:,1); %1 usec/ 1 nsec = 10^-6/10^-9 = 10^-3. Unit conversion
muon2(:,1) = 10.^(-3).*muon2(:,1);
muon3(:,1) = 10.^(-3).*muon3(:,1);
muon4(:,1) = 10.^(-3).*muon4(:,1);
fprintf('\n conversion done \n')
fprintf('calculating section 1 \n')
[freq1,nbins1]=hist(muon1(:,1),bins); %histogram command
[freq2,nbins2]=hist(muon2(:,1),bins);
[freq3,nbins3]=hist(muon3(:,1),bins);
[freq4,nbins4]=hist(muon4(:,1),bins);
freq1 = freq1(freq1~=0.0); nbins1 = nbins1(freq1~=0.0); %histogram bins values
freq2 = freq2(freq2~=0.0); nbins2 = nbins2(freq2~=0.0); %histogram bins values
freq3 = freq3(freq3~=0.0); nbins3 = nbins3(freq3~=0.0); %histogram bins values
freq4 = freq4(freq4~=0.0); nbins3 = nbins3(freq3~=0.0); %histogram bins values
%%%****run cftools with freq1 and nbins1 for not log plot with fit y = D*exp(-b*x)b= 1/life time*
%%cftools gui results are ""saved"" as .model files
for i = 1:length(freq1) %%0 bin values will cause an error so they are omitted in log plot
    if freq1(i) == 0 %their is an error when we do the log version of the plot in the code.
        freq1(i) = 1;
        fprintf(['error making data point for bin =',num2str(nbins1(i)),...
            '\n','replacing freq1 value of zero with minimum of 1 \n'])
    end
end
for i = 1:length(freq2) %%0 bin values will cause an error so they are omitted in log plot
    if freq2(i) == 0 %their is an error when we do the log version of the plot in the code.
        freq2(i) = 1;
        fprintf(['error making data point for bin =',num2str(nbins1(i)),...
            '\n','replacing freq1 value of zero with minimum of 1 \n'])
    end
end
for i = 1:length(freq1) %%0 bin values will cause an error so they are omitted in log plot
    if freq1(i) == 0 %their is an error when we do the log version of the plot in the code.
        freq1(i) = 1;
        fprintf(['error making data point for bin =',num2str(nbins1(i)),...
            '\n','replacing freq1 value of zero with minimum of 1 \n'])
    end
end
for i = 1:length(freq3) %%0 bin values will cause an error so they are omitted in log plot
    if freq3(i) == 0 %their is an error when we do the log version of the plot in the code.
        freq3(i) = 1;
        fprintf(['error making data point for bin =',num2str(nbins4(i)),...
            '\n','replacing freq1 value of zero with minimum of 1 \n'])
    end
end
for i = 1:length(freq4) %%0 bin values will cause an error so they are omitted in log plot
    if freq4(i) == 0 %their is an error when we do the log version of the plot in the code.
        freq4(i) = 1;
        fprintf(['error making data point for bin =',num2str(nbins4(i)),...
            '\n','replacing freq1 value of zero with minimum of 1 \n'])
    end
end
%clear figure
logfreq1 = log(freq1); logfreq2 = log(freq2); logfreq3 = log(freq3); logfreq4 = log(freq4);
hold on
plot(nbins1,logfreq1,'ro','DisplayName','logfreq1 vs. nbins1','XDataSource',...
     'nbins1','YDataSource','logfreq1'); 
plot(nbins2,logfreq2,'bo','DisplayName','logfreq2 vs. nbins2','XDataSource',...
     'nbins2','YDataSource','logfreq2'); 
plot(nbins3,logfreq3,'ko','DisplayName','logfreq1 vs. nbins1','XDataSource',...
     'nbins3','YDataSource','logfreq3'); 
plot(nbins4,logfreq4,'ro','DisplayName','logfreq1 vs. nbins1','XDataSource',...
     'nbins4','YDataSource','logfreq1'); 

hold off
 figure(gcf) % Not sure what this specific line does.
fprintf('calculating section 1 done \n')

Coeffs = zeros(4,2); % <-- where the coefficents are stored

% Section 2: Fits
%Calculate first fit
hold on
coeff(1,:) = polyfit(nbins1(nbins1 < 12),logfreq1(nbins1 < 12),1);
coeff(2,:) = polyfit(nbins2(nbins2 < 10),logfreq2(nbins2 < 10),1);
coeff(3,:) = polyfit(nbins3(nbins3 < 12),logfreq3(nbins3 < 12),1);
coeff(4,:) = polyfit(nbins4(nbins4 < 12),logfreq4(nbins4 < 12),1);
f1= polyval(coeff(1,:),nbins1(nbins1 < 12));
f2= polyval(coeff(2,:),nbins2(nbins2 < 10));
f3= polyval(coeff(3,:),nbins3(nbins3 < 12));
f4= polyval(coeff(4,:),nbins4(nbins4 < 12));
error = .15*ones(1,length(nbins1)); %This is the errorbars calculation you see in the 
%graph. I need to eventaully put this as the Possion Error if we plan on
%usingthese errorbars.
plot(nbins1(nbins1 < 12),f1,'-b')
plot(nbins2(nbins2 < 10),f2,'-r')
plot(nbins3(nbins3 < 12),f3,'-k')
plot(nbins4(nbins4 < 12),f4)
hold off
% % hold off
coeff(:,1) = 1 ./ coeff(:,1);

fprintf('calculating section 2 done \n')
% % Plot Properties
hold on
% % Create axes
axes1 = axis;
% % Uncomment the following line to preserve the X-limits of the axes
% % xlim(axes1,[0.12973 12]);
% % Uncomment the following line to preserve the Y-limits of the axes
% % ylim(axes1,[3.5 8]);
% % Uncomment the following line to preserve the Z-limits of the axes
% % zlim(axes1,[-1 1]);
xlabel('Decay Time (\musec)'); % Create xlabel
ylabel('Log freq1uency of occurance (Events/bin )'); % Create ylabel
title('Muon Histogram for Trial 1 (V_H_V = ? V)'); % Create title
% %errorbar(nbins1,logfreq1,error,'Marker','o','LineStyle','none','Color','b'); 
% %errorbar creates errorbar points based on nbins1 and freq1
text(axes1(2)*.25,axes1(4)*.85, ['Trial 1 Model: ln y =  \tau *x + b ', '\tau = ',...
    num2str(coeff(1,1)), ' b =', num2str(coeff(1,2))],'Color','b')
text(axes1(2)*.25,axes1(4)*.80, ['Trial 2 Model: ln y =  \tau *x + b ', '\tau = ',...
    num2str(coeff(2,1)), ' b =', num2str(coeff(2,2))],'Color','r')
text(axes1(2)*.25,axes1(4)*.75, ['Trial 3 Model: ln y =  \tau *x + b ', '\tau = ',...
    num2str(coeff(3,1)), ' b =', num2str(coeff(3,2))],'Color','k')
text(axes1(2)*.25,axes1(4)*.70, ['Trial 4 Model: ln y =  \tau *x + b ', '\tau = ',...
    num2str(coeff(4,1)), ' b =', num2str(coeff(4,2))])
hold off

%% Uncomment lines below aftering runing cftool.m, plotting (or load session...
%%session muon.cfit), and export the fits as Matlab object files ex. fittedmodel1,
%%fittedmodel2, etc...
% fit1 = fittedmodel1 %calls the matlab fit data, if you have not run cftool
% fit2 = fittedmodel2 %I have stored this as muon.mat file so you can see what
%                     %this code does by itself
% 
% coeffvals1 = coeffvalues(fittedmodel1); %loads coeffient values
% coeffvals2 = coeffvalues(fittedmodel2);
% xlabel('Decay Time (\musec)'); % Create xlabel
% ylabel('freq1uency of occurance (Events/bin )'); % Create ylabel
% title('Muon Histograms'); % Create title
% axes2 = axis;
% text(axes2(2)*.25,axes2(4)*.55, ['Model: y =  D*exp(1/\tau*x) ', '\tau = ',...
%     num2str(coeffvals1(2)), '\mus D =', num2str(coeffvals1(1))],'Color','r')
% text(axes2(2)*.25,axes2(4)*.5, ['Model: y = D*exp(1/\tau*x) ', '\tau = ',...
%     num2str(coeffvals2(2)), '\mus D =', num2str(coeffvals2(1))],'Color','b')
%%the text() code above generates a text box to display the values of the fits
%%as /mu and /tau indicate text() is special in that it accept very basic
%%Latex code in the [] variable
