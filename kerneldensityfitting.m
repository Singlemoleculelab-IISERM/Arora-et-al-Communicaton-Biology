function kerneldensityfitting
clear all
close all
fclose all
[F]=textread('Data_LR_2000.txt','%n','headerlines',0);
N=length(F);
s=std(F);
r=iqr(F);
M=min(s,r);
bandwidth=(1.06*(N^(-1/5))*M)
fitdata = fitdist(F,'Kernel','Bandwidth',bandwidth);
[g,y] = ksdensity(F,'Bandwidth',bandwidth);
x = (min(F)):1:(max(F));
y1 = pdf(fitdata,x);
plot(x,y1,'red');
matrix=[g y];
matrix2=[x,y1]
g=g';
y=y';
x=x';
y1=y1';
dlmwrite('F_5_5_fit_default_X.txt',g,'delimiter','');
dlmwrite('F_5_5_fit_default_y.txt',y,'delimiter','');
dlmwrite('F_5_5_fit_prov_X.txt',x,'delimiter','');
dlmwrite('F_5_5_fit_prov_y1.txt',y1,'delimiter','');
end

