function Lc_writing
close all;
fclose all;
clear all;
fid2=fopen('Lc_3000.txt','a+');
% fprintf(fid2,'%s\n','delLc(nm)');
di=dir('LpLc_**.txt');
for i=1:length(di);
    clear  delLc;
    name=di(i).name;
    fprintf(1,'%s %s\n','analyzing file : ',name);
     l= dlmread(name,' ',0,1)
    fileID = fopen(name);
%    l=readtable(name)
    %l=load(name);
    Lc=l(:,6)
    Lc=Lc;
    n=length(Lc)
     for j=1:n-1; 
        L=Lc(j+1)
        L1=Lc(j)
        delLc(j)=Lc(j+1)-Lc(j)
  end
% fprintf(fid2,'%s %e %e\n',name ,delLc);
fprintf(fid2,'%s %e\n' , Lc(1), delLc);  %Lc(1),
%fprintf(fid2,'%s %e %e\n' ,name ,Lc(1), delLc);  %Lc(1),
end