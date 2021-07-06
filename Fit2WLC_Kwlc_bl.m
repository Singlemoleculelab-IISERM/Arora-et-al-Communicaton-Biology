function Fit2WLC_Kwlc_b1

%This program is modified for fitting unfolding force curves and can fit 
%stretching using wlc models. It helps in fitting the total number of peaks
%in unfolding expts. It writes in a single text file with different rows
%for different peaks for a single file. %% 
clear 'all';
close 'all';
global out;
fclose('all');
folder=('F:\Force_ramp_Direct_indirect\5thNOV2020_cdh27pcdh12\1000_processed-2020.11.11-17.14.37\accepted');
%%Provide the current working folder name here.....
cd(folder);
mkdir(folder,'accepted');
mkdir(folder,'rejected');
mkdir(folder,'singlepeak');
di=dir('LR**.txt');
for i=1:length(di);
    clear s A str n n2 xplot yplot l x y ycorr k findyp orig ymax xmax c_info x1 y1 xc yc;
    clear bline ymaxf xmaxf;
    name=di(i).name;
    fprintf(1,'%s %s\n','analyzing file : ',name);
    l = load(name);
    xa = (l(:,1));
    ya = (l(:,2));
    
  
    N3 = horzcat(xa,ya);
    H_n=figure;
    %     set(H_n,'PaperUnits','centimeters')
    %     xSize = 400;  ySize = 350;
    %     xLeft = (400-xSize)/3;  yTop = (1000-ySize)/3;
    %     set(H_n,'position',[xLeft+xSize+xSize yTop+(ySize/2) xSize ySize])
    plot(xa,ya,'.-k')
    zoom on
    pause
    zoom off;
    k1=input('enter the operation code(1=copyfile, 2=reject, 3=singlepeak):');
    switch k1;
        case 1;
            zoom on
            pause
            zoom off;
            disp('accept');
            pause
            k= input('enter if origin is correct:');
            if isempty(k)==1                     % logical value 1 indicates true
                 xa = xa-xa(orig);
                plot(xa,ya,'.-k');
            else
                zoom on
                pause
                zoom off
                dcm_obj0 = datacursormode(H_n);
                set(dcm_obj0, 'enable', 'on')
                pause
                set(dcm_obj0, 'enable', 'off')
                c_info0 = getCursorInfo(dcm_obj0);
                orig =  c_info0.DataIndex;
                xa = xa-xa(orig);
                ya = ya - ya(orig);
                delete(H_n)
                dpts = round(length(xa)/16);
            xb=vertcat(xa(orig),xa(end-dpts:end));
            yb=vertcat(ya(orig),ya(end-dpts:end));
            %             ord = [1 2 3 4 12 15];
            %             for jj = 1: length(ord);
            p=polyfit(xb,yb,1);
            bline = polyval(p,xa);
            ya = bline - ya;
            H_k=figure;
            
            plot(xa,ya,'.-k');
            end    
            hold on;
             zoom on
            pause
            zoom off;
            select_rect('on');
            disp('Select Baseline');
            pause
            b2=find(xa>=out(1) & xa<=out(3));%b2 gives the limits of the region to be fitted. Fitting proceeds like above
            select_rect('clean');
            delete(H_n)
            xin = xa(b2);
            yin = ya(b2);
            %     fid2=fopen('Name_lp_CL_y0_gof.txt','a+');
            %     fprintf(fid2,'%s %s %s  %s %s\n','name','lp(nm)','Contour Length(nm)','y0','Goodness of fit');
            H_n=figure;
            plot(xa,ya,'.-k',xin,yin)
            N3 = horzcat(xa,ya);
            N = input('How many unbindings do you observed? : ');
            for i1 = 1:N
                
                clear dcm_obj c_info dcm_obj1  d_info x1 y1
                %         H_n=figure;
                %         plot(xa,ya,'.-k',xin,yin)
                zoom on
                pause
                zoom off
                % enable data cursor mode
                dcm_obj = datacursormode(H_n);
                set(dcm_obj, 'enable', 'on')
                pause
                % do disable data cursor mode use
                set(dcm_obj, 'enable', 'off')
                c_info = getCursorInfo(dcm_obj);
                zoom on
                pause
                zoom off
                % enable data cursor mode
                dcm_obj1 = datacursormode(H_n);
                set(dcm_obj1, 'enable', 'on')
                pause
                % do disable data cursor mode use
                set(dcm_obj1, 'enable', 'off')
                d_info = getCursorInfo(dcm_obj1);
                x1=xa((c_info.DataIndex):(d_info.DataIndex));
                y1=ya((c_info.DataIndex):(d_info.DataIndex));
                x1 = vertcat(xin,x1);
                y1 = vertcat(yin,y1);
                delete(H_n)
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fit for WLC %%%%%%    %%%
                clear yfit cm1f cm2f cm3f ansc cm4f yW1fit yW2fit Lcn gof1 gof2 gof3 Lguesf yfitf yfitS Rf RS jf jS a b c d e f g Kwlc;
                x=x1;
                y=y1;
                %                 l3=length(y);
                W1=fittype('(4.1/lp)*((1./(4*(1-x/lc).^2))+(x/lc)-0.25)+y0','coeff',{'lc' 'y0'},'problem',{'lp'});  %fittype for fiting with some specific types
                W2=fittype('(4.1/lp)*((1./(4*(1-x/lc).^2))+(x/lc)-0.25)+y0','coeff',{'lp' 'lc'},'problem',{'y0'});
                W3=fittype('(4.1/lp)*((1./(4*(1-x/lc).^2))+(x/lc)-0.25)+y0','coeff',{'lp' 'lc' 'y0'});
                optsW1=fitoptions(W1);
                optsW1.MaxFunEvals = [50000];
                optsW1.MaxIter = [50000];
                optsW2=fitoptions(W2);
                optsW2.MaxFunEvals = [50000];
                optsW2.MaxIter = [50000];
                optsW3=fitoptions(W3);
                optsW3.MaxFunEvals = [50000];
                optsW3.MaxIter = [50000];
                Lguesm=x(end)+1;
                cm1= [0.4 Lguesm 0.0001];
                cm2=nan*ones(2);
                cm3=nan*ones(2);
                cm4=nan*ones(3);
                optsW1.StartPoint = [cm1(2) cm1(3)];
                [funW1,goff]=fit(x,y,W1,optsW1,'problem',{cm1(1)});
                gof1=goff.adjrsquare;
                yW1fit=feval(funW1,x1);
                cm2=coeffvalues(funW1);
                optsW2.StartPoint = [cm1(1) cm2(1)];
                [funW2,goff]=fit(x1,y1,W2,optsW2,'problem',{cm2(2)});
                gof2=goff.adjrsquare;
                yW2fit=feval(funW2,x1);
                cm3=coeffvalues(funW2);
                optsW3.StartPoint = [cm3(1) cm3(2) cm2(2)];
                [funW3,goff]=fit(x1,y1,W3,optsW3);
                gof3=goff.adjrsquare;
                yfit=feval(funW3,xa);
                cm4=coeffvalues(funW3);
%               
                xc=xa(d_info.DataIndex);
                yc=ya(d_info.DataIndex);
%                 xd(i1)=xa(d_info.DataIndex);
 
                N3 =horzcat(N3,yfit);
                ymax=max(ya)
                H_s=figure;
                ylim([yfit(1) ymax])
                hold on
                plot(xa,ya,'.-k',xa,yfit,'-r');
                hold on
                xlabel('Extension(nm)'),ylabel('Force(pN)');
                pause
                a= cm4(1)*ymax*0.2433; %%%% lp*F*beta, beta is 1/4.11
                    b= cm4(2)*cm4(1)*0.2433; %%%Lc*lp*beta
                    %c= 1/cm4(4);
                    c=2*b*(1+a);
                    d=3+5*a;
                    e=8*((a)^(5/2));
                    f=d+e;
                    g=c/f;
                    Kwlc=1/g;
                name_create = strcat('LpLc_',name);
                fid2=fopen(name_create, 'a+');
                %fprintf(fid2, '%s, %s, %s %s %s %s %s %s %s\n', 'name', 'lp', 'Lc', 'Kwlc','y0', 'gof', 'CL', 'Fmax');
                %fprintf(fidn, '%s, %s, %s\n', 'name', 'Fub', 'CL');
               %fprintf(fid2,'%s %s %s %s %s %s %s\n','lp(nm)','lc(nm)','y0','GOF','xc','yc','ym');
                
                fprintf(fid2,'%s %e %e %e %e %e %e %e\n',name,cm4(1),cm4(2),Kwlc,cm4(3),gof3,xc,yc); %cm4(1)=lp, cm4(2)=lc
                name2=(sscanf(name,'%c'));
                name3=strcat('new_WLCfits_',name2);
                % dlmwrite(nm1,xd, 'delimiter','\t')
                dlmwrite(name3,N3, 'delimiter','\t')
                
            end
            %fprintf(fidn,'%s  %e %e %e %e %e %e %e %e %e %e\n',name(end-12:end), xd);
            movefile(name,'F:\Force_ramp_Direct_indirect\5thNOV2020_cdh27pcdh12\1000_processed-2020.11.11-17.14.37\accepted\accepted');
            delete(H_s)
            
        case 2;
            delete(H_n);
            disp('reject');
            movefile(name,'F:\Force_ramp_Direct_indirect\5thNOV2020_cdh27pcdh12\1000_processed-2020.11.11-17.14.37\accepted\rejected');
            %                 fclose (fid2);
     case 3;
            delete(H_n);
            disp('singlepeak');
            movefile(name,'F:\Force_ramp_Direct_indirect\5thNOV2020_cdh27pcdh12\1000_processed-2020.11.11-17.14.37\accepted\singlepeak');
    end
    %     fclose 'all'
end
end
