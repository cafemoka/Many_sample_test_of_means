# Many sample test of means

Given g groups, 

Null hypothesis: 

![null_hypothesis_many_samples](https://user-images.githubusercontent.com/54297018/66250211-7bc44f00-e77a-11e9-8f7a-8b2d0c1ce075.png)

Parametric test: Analysis of variance (ANOVA) 

Nonparametric test: Kruskal-Wallis test 


# 1. Analysis of Variance (ANOVA) 

![Screen Shot 2019-10-05 at 11 10 03 AM](https://user-images.githubusercontent.com/54297018/66248343-cc2eb300-e760-11e9-8308-3a0cdf57ef49.png)

Suppose we have midterm scores of five classes. Each class has 120 students. 
We will test whether the score distributions of 5 classes are the same by ANOVA. 


```Matlab 
clear all; 

% load the dataset 
% 'grades' has 5 columns and 120 rows. 
% Each row represents a student, and each column represents a class. 
grades = load('grades.txt'); 

% Perform ANOVA 
[p,tbl] = anova1(grades); 
``` 

![anova_result1](https://user-images.githubusercontent.com/54297018/66248064-aa7ffc80-e75d-11e9-9341-afc4c50e39e2.png)
![anova_result2](https://user-images.githubusercontent.com/54297018/66248074-c388ad80-e75d-11e9-936a-668da47ae282.png)

>> p

p =

    1.0000
    
    
Check the elements in the output 'tbl'. 


```Matlab 

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
```

ans =

    0.1600    0.1600

```Matlab 
% degrees of freedom in across 
df_across = g - 1; 
% Check df_across and the element of tbl 
[df_across tbl{2,3}] 
``` 

ans =

     4     4
     
```Matlab 
% Divide by df_across 
s2A = s2A/df_across; 
% Check 
[s2A tbl{2,4}] 
```

ans =

    0.0400    0.0400

```Matlab
% 2. Estimate within-group sample variance 
s2W = sum(sum((grades - repmat(barxi,[n(1) 1])).^2)); 
% Check s2W and the element of tbl 
[s2W tbl{3,2}]
```

ans =

   1.0e+04 *

    3.2808    3.2808
    

```Matlab 
% degrees of freedom in between 
df_between = sum(n - 1); 
% Check df_across and the element of tbl 
[df_between tbl{3,3}] 
```

ans =

   595   595
   

```Matlab 
% Divide by df_between 
s2W = s2W/df_between; 
% Check 
[s2W tbl{3,4}] 
```

ans =

   55.1392   55.1392
   
   

```Matlab 
% 3. Estimate test statistic 
F = s2A/s2W; 
% Check 
[F tbl{2,5}] 
``` 

ans =

   1.0e-03 *

    0.7254    0.7254

```Matlab 
% 4. Estimate p-value 
myp = fcdf(F,g-1,sum(n)-1,'upper'); 
% Check pvalues 
[p myp] 
``` 

ans =

    1.0000    1.0000
    

The null hypothesis is accepted. There is no difference between the grades of five classes. 



# 2. Kruskal-Wallis test

The Kruskal-Wallis test is one-way ANOVA on ranks and the extended version of the Wilcoxon ranksum test (Mann-Whitney U test). 
The procedure of Kruskal-Wallis test is similar to Wilcoxon ranksum test. 

1. Assign ranks on all elements of the given data
2. Average ranks in each group
3. Estimate test statistic
![H](https://user-images.githubusercontent.com/54297018/66248579-3f392900-e763-11e9-98e2-cd485d34c923.png)
4. Estimate test distribution 
5. Estimate p-value 


The following example is from https://dermabae.tistory.com/168, https://en.wikipedia.org/wiki/Kruskal–Wallis_one-way_analysis_of_variance#cite_note-Laerd-1. 

![Screen Shot 2019-10-05 at 11 32 06 AM](https://user-images.githubusercontent.com/54297018/66248610-d605e580-e763-11e9-8a07-a116886896a7.png)
![Screen Shot 2019-10-05 at 11 32 16 AM](https://user-images.githubusercontent.com/54297018/66248625-19605400-e764-11e9-9a85-0a78cb20a1d8.png)


```Matlab 

