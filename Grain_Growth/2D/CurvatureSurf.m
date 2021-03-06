function Khist=CurvatureSurf(savedir,tn,mboxsize)
% clear
% savedir='/media/Disk2/Results/2D/Fric2000_m2_k3_init2000/30/';
% tn=40000
% mboxsize=2000;
nboxsize=mboxsize;
tni=0;
Kdata=importdata([savedir 'K_' num2str(tn) '.txt']);
Kraw=Kdata(:,4);Kraw(abs(Kraw)>0.04)=[];
    
    Kneg=zeros(mboxsize,nboxsize)*nan;
%     Kindsneg=zeros(mboxsize,nboxsize);
%     Kindspos=zeros(mboxsize,nboxsize);
    for i=1:length(Kdata)
        if Kdata(i,4)<=0 % select the negative component
            Kneg(Kdata(i,1)+1,Kdata(i,2)+1)=Kdata(i,4);
%             Kindsneg(Kdata(i,1)+1,Kdata(i,2)+1)=Kdata(i,3);
        end
    end
    Kpos=zeros(mboxsize,nboxsize)*nan;
    for i=1:length(Kdata)
        if Kdata(i,4)>=0 % select the positive component
            Kpos(Kdata(i,1)+1,Kdata(i,2)+1)=Kdata(i,4);
%             Kindspos(Kdata(i,1)+1,Kdata(i,2)+1)=Kdata(i,3);
        end
    end
     Kneg(logical(isnan(Kneg) .* ~isnan(Kpos)))=0;%-Kpos(boolean(isnan(Kneg) .* ~isnan(Kpos)));
     Kpos(logical(isnan(Kpos) .* ~isnan(Kneg)))=0;
     Kmat=Kpos; % we like negative component
     Kmat(abs(Kneg+Kpos)>0.005)=nan;
     Kmat(Kmat>0.04)=nan;
     Kmat(Kmat<-0.04)=nan;

    Khist=Kmat(~isnan(Kmat));
    
figure;
boxsize=500;
surf(Kpos(1:boxsize,1:boxsize));view([0 90]);
colormap jet;
shading flat
axis equal;
box on;grid off
colorbar;
title ([savedir ' (tn=' num2str(tn) ')'])
set(gca,'CLim', [0 0.02])
axis([0 boxsize 0 boxsize])
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
