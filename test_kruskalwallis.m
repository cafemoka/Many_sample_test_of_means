% Kruskal-Wallis test 
data = [27 25 21 23 22 24 25 25 18 19 20 23 19 23 19 18 18 17]; 
group = [1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3]; 

[p_kw,tbl_kw] = kruskalwallis(data,group); 

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

[tbl; tbl_anova] 
