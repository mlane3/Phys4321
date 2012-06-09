%%  Muon.m
%Muon Analysis Program.
%filename = input('Please instert the EXACT path name of the file... \n', 's')
%fprintf('importing file \n');

% Variables
clear
clc
binsize = 60 %you can adjust binsize here
%Uncommit to specify binsizes
%binsize = input('What binsize # it? \n');
%trial = input('What trial # it? \n');

%Section 1: Importing Data

Raw = importdata('\Data\12-06-05-14-52-12-06-07-13-52-00.data',' '); 
%%you need to locate the file and change this ^^^^ to the right location
%Every number less than 40,000 is the time measured in nanoseconds,
%%between successive signals and, background aside, identifies a muon decay.
fprintf('converting data \n')
muon1 = Raw(find(Raw(:,1) < 40000),:); %cell iteration in this step is 
%intentional as the file size of .data makes up varies.

muon1(:,1) = 10.^(-3).*muon1(:,1); %1 usec/ 1 nsec = 10^-6/10^-9 = 10^-3.
fprintf('\n conversion done \n')
fprintf('calculating section 1 \n')
[freq,nbins]=hist(muon1(:,1),binsize); %histogram command
freq = freq(freq~=0.0); nbins = nbins(freq~=0.0); %histogram bins w/ 
%%0 will cause an error so they are omitted
for i = 1:length(freq)
    if freq(i) == 0
        freq(i) = 1;
        fprintf(['error making data point for bin =',num2str(nbins(i)),...
            '\n','replacing freq value of zero with minimum of 1 \n'])
    end
end
clear figure
logfreq = log(freq);
plot(nbins,logfreq,'o','DisplayName','logfreq vs. nbins','XDataSource',...
    'nbins','YDataSource','logfreq'); 
figure(gcf)
fprintf('calculating section 1 done \n')

%% Section 2: Fits
%Calculate first fit
hold on
coeff = polyfit(nbins,logfreq,1);
f= polyval(coeff,nbins);
plot(nbins,f,'-')
hold off
error = .15*ones(1,length(nbins)); %This is the errorbars calculation you see in the 
%%graph. I need to eventaully put this as the Possion Error if we plan on
%%usingthese errorbars.

%Calculate second fit
% hold on
nbins2 = nbins(nbins < 15); y2 = logfreq(nbins < 15);
coeff2 = polyfit(nbins2,y2,1);
f2 = polyval(coeff2,nbins2);
hold on
plot(nbins2,f2,'-r')
hold off
% hold off
fprintf('calculating section 2 done \n')

% Plot Properties
hold on
% Create axes
axes1 = axis;
% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.12973 12]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[3.5 8]);
% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-1 1]);
xlabel('Decay Time (\musec)'); % Create xlabel
ylabel('Log frequency of occurance (Events/bin )'); % Create ylabel
title('Muon Histogram for Trial 1 (V_H_V = ? V)'); % Create title
errorbar(nbins,logfreq,error,'Marker','o','LineStyle','none','Color','b');
text(axes1(2)*.25,axes1(4)*.75, ['Model: ln y =  \tau *x + b ', '\tau = ',...
    num2str(coeff(1)), ' b =', num2str(coeff(2))],'Color','b')
text(axes1(2)*.25,axes1(4)*.80, ['Model: ln y =  \tau *x + b ', '\tau = ',...
    num2str(coeff2(1)), ' b =', num2str(coeff2(2))],'Color','r')
hold off
hold off

%% Section 3 Calcuations (unnecessary junk code section)
% nbins1 = []; A = []; B = []; y1 = [];
% nbins1 = nbins(2:end); y1 = y(2:end);
% decider = input('input where curve starts to deviate \n','s');
% 
% A = zeros(length(nbins1
% B = zeros(length(y1));
% for i = 1:length(nbins1)
%     if nbins1(i) < str2num(decider)
%        A(i) = nbins1(i);
%        B(i) = y1(i);
%     end
% end
% nbinsnew = A(A~=0);
% ynew = B(B~=0);
% plot(nbinsnew,ynew,'ro')
% h = polytool(nbinsnew,ynew)