clear all
close all
clc

load('DistractorDiff')

Freq = [Data1(:,1); Data2(:,1)];
Max = [Data1(:,2); Data2(:,2)];
D = [Data1(:,3); Data2(:,3)];

Colors = linspecer(11);
Colors = Colors(D + 1,:);

fig = figure;
scatter3(Freq, Max, D, 80, Colors, 's','LineWidth',3)
title('Distractor Task Difficulty')
xlabel('Frequency')
ylabel('Max number')
zlabel('Difficulty')
set(fig,'Color',[.5 .5 .5])