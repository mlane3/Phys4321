%%  Muon2.m
%Muon Analysis Program.
%filename = input('Please instert the EXACT path name of the file... \n', 's')
%fprintf('importing file \n');

%% Section 1 Load Data
%%%%%%%% COEFF's HAS THE IMPORTANT INFO IN THIS FILE!!! First one is tau!
%%%%%%%%%%%%%%%%% It caculatest that what if questions about what if I cut
%%%%%%%%%%%%%%%%% off for background was different?
% Variables
clear
clc
bins = 60 %you can adjust # of bins here
%Uncommit to specify bins
% bins = input('What bins # it? \n');
% trial = input('What trial # it? \n');

%Section 1: Importing Data

Raw = importdata('\Data\12-06-07-14-10.data',' '); %Replace line here
%%you need to locate the file and change this ^^^^ to the right location
%Every number less than 40,000 is the time measured in nanoseconds,
%%between successive signals and, background aside, identifies a muon decay.
fprintf('converting data \n')
muon1 = Raw(find(Raw(:,1) < 40000),:); %cell iteration in this step is 
%intentional as the file size of .data makes up varies. This on stips the
%invalid points

muon1(:,1) = 10.^(-3).*muon1(:,1); %1 usec/ 1 nsec = 10^-6/10^-9 = 10^-3. Unit conversion
fprintf('\n conversion done \n')
fprintf('calculating section 1 \n')
[freq,nbins]=hist(muon1(:,1),bins); %histogram command
freq = freq(freq~=0.0); nbins = nbins(freq~=0.0); %histogram bins values

%%%****run cftools with freq and nbins for not log plot with fit y = D*exp(-b*x)b= 1/life time*
%%cftools gui results are ""saved"" as .model files
for i = 1:length(freq) %%0 bin values will cause an error so they are omitted in log plot
    if freq(i) == 0 %their is an error when we do the log version of the plot in the code.
        freq(i) = 1;
        fprintf(['error making data point for bin =',num2str(nbins(i)),...
            '\n','replacing freq value of zero with minimum of 1 \n'])
    end
end
clear figure
logfreq = log(freq);
 plot(nbins,logfreq,'o','DisplayName','logfreq vs. nbins','XDataSource',...
     'nbins','YDataSource','logfreq'); 
 figure(gcf) % Not sure what this specific line does.
fprintf('calculating section 1 done \n')

Coeffs = zeros(length(nbins)-2,2); % <-- where the coefficents are stored
x2 = zeros(length(nbins)-2,1);
%% Section 2: Fits
%Calculate first fit
hold on
for i = 1:length(nbins)-2;
coeff = polyfit(nbins(1:end-i),logfreq(1:end-i),1);
f= polyval(coeff,nbins(1:end-i));
x2(i) = length(f)
%plot(nbins(1:end-i),f,'-')
coeff(1) = 1./coeff(1);  %put the slope coefficent in terms of tau
Coeffs(i,1) = coeff(1);
Coeffs(i,2) = coeff(2);
end
hold off
%error = .15*ones(1,length(nbins)); %This is the errorbars calculation you see in the 
%%graph. I need to eventaully put this as the Possion Error if we plan on
%%usingthese errorbars.
figure(2)

plot(x2,abs(Coeffs(:,1)),'o');

% %%The second fit is where we limit the data in some way, in this case
% %%.... the histogram is limited to bins with the x < 15 usec
% nbins2 = nbins(nbins < 10); freq2 = freq(nbins < 10);
% y2 = logfreq(nbins < 10);
% coeff2 = polyfit(nbins2,y2,1);
% f2 = polyval(coeff2,nbins2);
% hold on
% plot(nbins2,f2,'-r')
% hold off
% % hold off


fprintf('calculating section 2 done \n')
% % Plot Properties
% hold on
% % Create axes
% axes1 = axis;
% % Uncomment the following line to preserve the X-limits of the axes
% % xlim(axes1,[0.12973 12]);
% % Uncomment the following line to preserve the Y-limits of the axes
% % ylim(axes1,[3.5 8]);
% % Uncomment the following line to preserve the Z-limits of the axes
% % zlim(axes1,[-1 1]);
% xlabel('Decay Time (\musec)'); % Create xlabel
% ylabel('Log frequency of occurance (Events/bin )'); % Create ylabel
% title('Muon Histogram for Trial 1 (V_H_V = ? V)'); % Create title
% %errorbar(nbins,logfreq,error,'Marker','o','LineStyle','none','Color','b'); 
% %errorbar creates errorbar points based on nbins and freq
% % text(axes1(2)*.25,axes1(4)*.75, ['Model: ln y =  \tau *x + b ', '\tau = ',...
% %     num2str(coeff(1)), ' b =', num2str(coeff(2))],'Color','b')
% % text(axes1(2)*.25,axes1(4)*.80, ['Model: ln y =  \tau *x + b ', '\tau = ',...
% %     num2str(coeff2(1)), ' b =', num2str(coeff2(2))],'Color','r')
% hold off

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
% ylabel('frequency of occurance (Events/bin )'); % Create ylabel
% title('Muon Histograms'); % Create title
% axes2 = axis;
% text(axes2(2)*.25,axes2(4)*.55, ['Model: y =  D*exp(1/\tau*x) ', '\tau = ',...
%     num2str(coeffvals1(2)), '\mus D =', num2str(coeffvals1(1))],'Color','r')
% text(axes2(2)*.25,axes2(4)*.5, ['Model: y = D*exp(1/\tau*x) ', '\tau = ',...
%     num2str(coeffvals2(2)), '\mus D =', num2str(coeffvals2(1))],'Color','b')
%%the text() code above generates a text box to display the values of the fits
%%as /mu and /tau indicate text() is special in that it accept very basic
%%Latex code in the [] variable
