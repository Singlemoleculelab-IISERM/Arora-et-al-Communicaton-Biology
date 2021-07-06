function force_writing  %% this program is used to get the force after WLC fitting of the data
close all;
fclose all;
clear all;
fid2=fopen('F_3000.txt','a+');
% fprintf(fid2,'%s\n','delLc(nm)');
di=dir('LpLc**.txt');
for i=1:length(di);
    clear  delLc;
    name=di(i).name;
    fprintf(1,'%s %s\n','analyzing file : ',name);
    l= dlmread(name,' ',0,1) % 0 and 1 are the row and column offsets resp.
%     fileID = fopen(name);
%    l=readtable(name)
%     l=load(name);
    Lf=l(:,7);
    Lf=Lf;
%     n=length(Lc)
%      for j=1:n-1; 
%         L=Lc(j+1)
%         L1=Lc(j)
%         delLc(j)=Lc(j+1)-Lc(j)
%   end
  fprintf(fid2,' %e\n', Lf');
   %fprintf(fid2,'%s %e\n',name ,Lf);
end