clear all; 

grades = load('grades.txt'); 

% Perform ANOVA 
[p,tbl] = anova1(grades); 


% Check the elements in the output 'tbl' 
% 1. Estimate across-group sample variance 
% the number of groups 
g = 5; 
% the number of samples in a group
% all groups have 120 samples. 
n = size(grades,1)*ones(1,5); 
% Estimate the mean of all grades 
barx = mean(grades(:)); 
% Estimate the mean of each group 
barxi = mean(grades,1); 
% Estimate across-group sample variance 
s2A = sum(n.*((barxi - barx).^2)); 
% Check s2A and the element of tbl 
[s2A tbl{2,2}]

% degrees of freedom in across 
df_across = g - 1; 
% Check df_across and the element of tbl 
[df_across tbl{2,3}] 

% Divide by df_across 
s2A = s2A/df_across; 
% Check 
[s2A tbl{2,4}] 

% 2. Estimate within-group sample variance 
s2W = sum(sum((grades - repmat(barxi,[n(1) 1])).^2)); 
% Check s2W and the element of tbl 
[s2W tbl{3,2}]

% degrees of freedom in between 
df_between = sum(n - 1); 
% Check df_across and the element of tbl 
[df_between tbl{3,3}] 

% Divide by df_between 
s2W = s2W/df_between; 
% Check 
[s2W tbl{3,4}] 

% 3. Estimate test statistic 
F = s2A/s2W; 
% Check 
[F tbl{2,5}] 

% 4. Estimate p-value 
myp = fcdf(F,g-1,sum(n)-1,'upper'); 
% Check pvalues 
[p myp] 




% Example 2 
strength = [82 86 79 83 84 85 86 87 74 82 ...
            78 75 76 77 79 79 77 78 82 79];
alloy = {'st','st','st','st','st','st','st','st',...
         'al1','al1','al1','al1','al1','al1',...
         'al2','al2','al2','al2','al2','al2'};
[p,tbl] = anova1(strength,alloy,'off'); 


