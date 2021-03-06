% one dimentional stationary particle and one phase field parameter in
% equilibrium with it
% function [eta,ME,E]=particle_onefield_1D(epsilon)
% savedir='onefield';
% mkdir(savedir)
% figure;
% clf
%% phase field parameters
L=[1];
alpha=[1];
beta=[1];
gamma=1;
kappa=[2];
minE=1/4*alpha*(2*beta-alpha)/beta^2;
% epsilon=10;

% geometry settings
p=1;
global nboxsize mboxsize
global delx
scale=10;
mboxsize=7*scale;
nboxsize=3;%1*scale;
delx=2/scale;
grainD=15*scale;

endtime=6;
timestepn=endtime*400;
delt=endtime/timestepn;

%savesettings
% save(strcat(pwd,'/',savedir,'/','setings.mat'))

% *** Phase Field Procedure *** (so small and simple piece of code!)
eta=zeros(mboxsize,nboxsize,p)-1;
% making initial structure
% x=fix(mboxsize*x);
% eta(1:x,:,1)=1;
% ppf is phase variable representing particles
%particledistro(nboxsize,mboxsize,particles_number,radius)
[ppf]=zeros(mboxsize,nboxsize);
ppf(1:fix(mboxsize/2),:)=1;
% eta(:,5,1)=1;
% eta(:,:,2)=1;
% eta(:,5,2)=0;
% eta=rand(gridn,gridn,p)*0.001;%-0.001;
eta2=zeros(mboxsize,nboxsize,p); %pre-assignment

for tn=1:timestepn
    for i=1:mboxsize
        for j=1:nboxsize
            del2=1/delx^2*(0.5*(eta(indg(i+1,mboxsize),j)-2*eta(i,j)+eta(indg(i-1,mboxsize),j))...
                +0.25*(eta(indg(i+2,mboxsize),j)-2*eta(i,j)+eta(indg(i-2,mboxsize),j)))...
                +1/delx^2*(0.5*(eta(i,indg(j+1,nboxsize))-2*eta(i,j)+eta(i,indg(j-1,nboxsize)))...
                +0.25*(eta(i,indg(j+2,nboxsize))-2*eta(i,j)+eta(i,indg(j-2,nboxsize))));
            %             sumterm=eta(i,j)*sum(eta(i,j).^2)-eta(i,j).^3;
            sumterm=0;
            detadtM=(-alpha.*eta(i,j)+beta.*eta(i,j).^3-kappa.*del2+...
                2*epsilon.*eta(i,j)*ppf(i,j).^2);
            detadt=-L.*(detadtM+2*gamma*sumterm);
            eta2(i,j)=eta(i,j)+delt*detadt;
            %             elovution of particle
            %             del2=1/delx^2*(0.5*(ppf(indg(i+1,gridn),j)-2*ppf(i,j)+ppf(indg(i-1,gridn),j))...
            %                 +0.25*(ppf(indg(i+2,gridn),j)-2*ppf(i,j)+ppf(indg(i-2,gridn),j)))...
            %                 +1/delx^2*(0.5*(ppf(i,indg(j+1,gridn))-2*ppf(i,j)+ppf(i,indg(j-1,gridn)))...
            %                 +0.25*(ppf(i,indg(j+2,gridn))-2*ppf(i,j)+ppf(i,indg(j-2,gridn))));
            %             sumterm=eta(i,j,:)*sum(eta(i,j,:).^2)-eta(i,j,:).^3;
            %             detadtM=(-alpha.*reshape(eta(i,j,:),1,p)+beta.*reshape(eta(i,j,:),1,p).^3-kappa.*reshape(del2,1,p)+...
            %                 2*epsilon.*reshape(eta(i,j,:),1,p)*ppf(i,j))+G;
            %             detadt=-L.*(detadtM+2*gamma*reshape(sumterm,1,p));
            %             eta2(i,j,:)=eta(i,j,:)+reshape(delt*detadt,1,1,2);

            if eta2(i,j)>1
                eta2(i,j)=1;
            end
            if eta2(i,j)<-1
                eta2(i,j)=-1;
            end
        end
    end

    eta=eta2;
    %{
    phi=eta.^2;
    % adding ppf to the phi to make particles positions to 1 inorder to
    % make mapping more clear to see it dosen't do anything with the matrix
    phi=phi+ppf;
    draw(phi,xparticle,yparticle,tn,eta,ppf)
    %}
    [ME,E]=calculateE(eta,ppf,mboxsize,nboxsize,delx,'low');
    drawE(rot90(rot90(E)),xparticle,yparticle,tn,eta,ppf)
    %     savegrains(eta,ppf,E,xparticle,yparticle,tn,savedir)
end
%

