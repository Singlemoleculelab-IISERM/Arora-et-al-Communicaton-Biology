function loadingratefromforcecurve
clear all
global out
close all
folder = 'F:\Force_ramp_Direct_indirect\5thNOV2020_cdh27pcdh12\1000_processed-2020.11.11-17.14.37\accepted\accepted';
mkdir(folder,'checked');
nm1 = '_1000_loadingrate.txt';
RNumb = rand;
str1 = num2str(RNumb);
name_create1 = strcat(str1,nm1);
fidn1=fopen(name_create1, 'w+');
fprintf(fidn1,'%s, %s, %s\n', 'File_name', 'slope');
j=1;
di=dir('LR**.txt');
for i=1:length(di)
    name=di(i).name;
    fprintf(1,'%s %s\n','analyzing file : ',name);
    fid=fopen(name);
    l = load(name);
    x = (l(:,1));
    y = (l(:,2));
    H_f=figure;
    set(H_f,'PaperUnits','centimeters')
    xSize = 400;  ySize = 350;
    xLeft = (400-xSize)/3;  yTop = (1000-ySize)/3;
    set(H_f,'position',[xLeft yTop+(ySize/2) xSize ySize])
    plot(x,y,'.-k')
    title(name)
    xlabel('extension')
    ylabel('force (pN)')
    grid on;
    zoom on 
    pause 
    zoom off
    delete(H_f)
    k=input('Enter the number of unfolding observed')
    for j=1:k
        H_g=figure;
        plot(x,y,'.-k')
        xlabel('extension')
    ylabel('force (pN)')
    grid on;
    zoom on 
    pause 
    zoom off
    select_rect('on');
    disp('Select contact portion of force curve. press any key when done');
    pause
    b1=find(x>=out(1) & x <=out(3));
    Contpoly=polyfit(x(b1),y(b1),1);
    Contfit=polyval(Contpoly,x(b1));
    select_rect('clean')
    hold on
    plot(x(b1),Contfit,'-c');
    hold off
    
    Slope=Contpoly(1);
    disp('press any key ');
    pause
    close(H_g);
    name1 = name(end-10:end);
    fprintf(fidn1, '%s %f\n',name1, Slope);
    end
%     movefile(name,'F:\Force_ramp_Direct_indirect\5thNOV2020_cdh27pcdh12\accepted\checked');

  
    
end
end
    