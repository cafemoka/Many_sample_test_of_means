# Many sample test of means

Given g groups, 

- Null hypothesis: 

![null_hypothesis_many_samples](https://user-images.githubusercontent.com/54297018/66250211-7bc44f00-e77a-11e9-8f7a-8b2d0c1ce075.png)

- Parametric test: Analysis of variance (ANOVA) 

- Nonparametric test: Kruskal-Wallis test 


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


```Matlab 
% Kruskal-Wallis test 
data = [27 25 21 23 22 24 25 25 18 19 20 23 19 23 19 18 18 17]; 
group = [1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3]; 

[p_kw,tbl_kw] = kruskalwallis(data,group); 
``` 

![kruskal_wallis_result1](https://user-images.githubusercontent.com/54297018/66262689-1a56bb80-e820-11e9-9249-555450228c48.png)
![kruskal_wallis_result2](https://user-images.githubusercontent.com/54297018/66262694-2e022200-e820-11e9-8d7e-fe205fc70969.png)


Check the results in 'tbl_kw'. 
The 'tbl_kw' is similar to the result of ANOVA on ranks. 
So, we estimate the rank of data first. 

```Matlab
% 1. Estimate the rank of samples 
% the number of samples 
n = length(data); 
% Sorting the data in the ascending order of elements 
[tval,tind] = sort(data,'ascend'); 
[val,ia] = unique(tval); 

% rerank for elements with the same value
orank = [1:n]; 
rrank = zeros(1,n);
for i = 1:length(ia), 
    if i < length(ia), 
        rrank(ia(i):(ia(i+1)-1)) = mean(orank(ia(i):(ia(i+1)-1))); 
    else
        rrank(ia(i):n) = mean(orank(ia(i):n));
    end 
end
rank_data = zeros(1,n);
rank_data(tind) = rrank;

% Compare with tbl_anova obtained by ANOVA on ranks  
[panova,tbl_anova] = anova1(rank_data,group);

[tbl_kw; tbl_anova] 
``` 

ans =

  8×6 cell 배열

    {'요인'}    {'SS'      }    {'df'}    {'MS'      }    {'카이제곱' }    {'확률>카이제곱'}
    {'그룹'}    {[196.0000]}    {[ 2]}    {[ 98.0000]}    {[  6.9927]}    {[     0.0303]}
    {'오차'}    {[280.5000]}    {[15]}    {[ 18.7000]}    {0×0 double}    {0×0 double   }
    {'총계'}    {[476.5000]}    {[17]}    {0×0 double}    {0×0 double}    {0×0 double   }
    {'요인'}    {'SS'      }    {'df'}    {'MS'      }    {'F'       }    {'확률>F'     }
    {'그룹'}    {[     196]}    {[ 2]}    {[      98]}    {[  5.2406]}    {[     0.0188]}
    {'오차'}    {[280.5000]}    {[15]}    {[ 18.7000]}    {0×0 double}    {0×0 double   }
    {'총계'}    {[476.5000]}    {[17]}    {0×0 double}    {0×0 double}    {0×0 double   }
    
    
The 'SS', 'df', and 'MS' are the same in 'tbl_kw' and 'tbl_anova'. 
But the test distributions are '카이제곱' in tbl_kw and 'F' in tbl_anova. 
This is because Kruskal-Wallis test does not assume that the data follows Gaussian distribution. 
Like Wilcoxon ranksum test, we can estimate all possible combinations of data by rearranging the group labels of the ranks of data. 
The number of all possible combinations were 

nchoosek(18,6)*nchoosek(12,6)/3! = 2,858,856. 

When I tried this, it took me one night. 
The exact test distribution of H under the null hypothesis that all groups have the same mean was as follows: 

![distribution_H](https://user-images.githubusercontent.com/54297018/66262742-be8d3200-e821-11e9-96a9-44a7661f4d25.png)


The matlab function 'kruskalwallis' does not use the exact test distribution, but use approximated test distribution by 카이제곱. 
The p-value obtained by the matlab function 'kruskalwallis', 'p_kw' was 0.0303. Therefore, the null hypothesis is rejected, and three groups have different distribution. 

The example of Kruskal-Wallis test is from https://dermabae.tistory.com/168, https://en.wikipedia.org/wiki/Kruskal–Wallis_one-way_analysis_of_variance#cite_note-Laerd-1. 

You can see detailed explanation in the following slides. 
![Screen Shot 2019-10-05 at 11 32 06 AM](https://user-images.githubusercontent.com/54297018/66248610-d605e580-e763-11e9-8a07-a116886896a7.png)
![Screen Shot 2019-10-05 at 11 32 16 AM](https://user-images.githubusercontent.com/54297018/66248625-19605400-e764-11e9-9a85-0a78cb20a1d8.png)




