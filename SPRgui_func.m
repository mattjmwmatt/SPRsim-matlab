%%
% *Surface Plasmon Resonance simulation GUI for multilayer structure at optical frequencies.*
% This code simulates surface plasmon resonance curves for a multilayer system
% containing BK7 glass, Titanium, Gold and an analyte layer via the Transfer-Matrix-Method(TMM).
%
%     - BK7 glass layer- ok
%
%     - Gold Layer - ok
%
%     - Titanium layer - ok
%
%     - Biosensor base layer (~3nm- eps ~ 2-3) - ok
%
%     - Biosensor layer  (~1nm - eps 2-3) - ok
%
%     - water background - ok
%
% *Author: Matheus Rotta Ribeiro - 1/22/2023*

function [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio)
addpath ExperimentalData

%lambda = SET BY GUI APPLICATION
lambda_nm = lambda./1e-9;  % nm units
lambda_um = lambda./1e-6;  % um units
% do not exceed 400-2000nm range (experimental data limits)

%% *BK7 glass prism, *$\lambda$*= 0.3-2.5 um  Schott *
%
% SCHOTT Zemax catalog 2017-01-20b (obtained from http://www.schott.com)

%layer 1: BK7 glass prism
load('NBK7SCHOTT.mat')%BK7 vendor data

%interpolating data to chosen lambda vector:
n_bk7_interp = spline(NBK7SCHOTT.wl_n,NBK7SCHOTT.n,lambda_um)*1.; %real part refractive index - BK7 prism
k_bk7_interp = spline(NBK7SCHOTT.wl_k,NBK7SCHOTT.k,lambda_um)*1.; %imaginary part refractive index - BK7 prism

[e_real,e_img] = RefractionIndex2Permittivity(n_bk7_interp,k_bk7_interp);% convert complex refraction index to complex permittivity

epsilon(1,:)=complex(e_real,e_img)/1; % first layer permittivity constants

%% *Titanium, *$\lambda$*= 0.40 - 10 um  Mash*
%
% I. D. Mash and G.P. Motulevich. Optical constants and electronic characteristics
% of titanium, Sov. Phys. JETP 36, 516-520 (1973)

%layer 2: Titanium adhesion layer
load('MashTitanium.mat');% Mashexperimental data

%interpolating data to chosen lambda vector:
n_ti_interp = spline(MashTitanium.wl,MashTitanium.n,lambda_um); %real part refractive index - Ti adhesion layer
k_ti_interp = spline(MashTitanium.wl,MashTitanium.k,lambda_um); %imaginary part refractive index - Ti adhesion layer

[e_real,e_img] = RefractionIndex2Permittivity(n_ti_interp,k_ti_interp);% convert complex refraction index to complex permittivity
epsilon(2,:)=complex(e_real,-e_img); % second layer permittivity constants

%d_ti= SET BY GUI APPLICATION; %thickness of Titanium layer 
d(2)=d_ti; %second layer thickness (nm)

%% *Gold 25 nm, *$\lambda$*= 300- 2000 nm  Yakubovsky (very close to 53 nm data)*
%
% D. I. Yakubovsky, A. V. Arsenin, Y. V. Stebunov, D. Yu. Fedyanin, V. S.
% Volkov. Optical constants and structural properties of thin gold films, Opt.
% Express 25, 25574-25587 (2017)

%layer 2: Titanium adhesion layer
load('YakubovskyGold25nm.mat')% Yakubosky 25 nm experimental data

%interpolating data to chosen lambda vector:
n_au_interp = spline(YakubovskyGold25nm.wl,YakubovskyGold25nm.n,lambda_um); %real part refractive index - Gold layer
k_au_interp = spline(YakubovskyGold25nm.wl,YakubovskyGold25nm.k,lambda_um); %imaginary part refractive index - Gold layer

[e_real,e_img] = RefractionIndex2Permittivity(n_au_interp,k_au_interp);% convert complex refraction index to complex permittivity
epsilon(3,:)=complex(e_real,-e_img); % third layer permittivity constants

%d_au = SET BY GUI APPLICATION; %thickness of gold layer
d(3)=d_au; %third layer thickness (nm)

%% Biosensor layer + Water as background 
%n_water  = set by gui application
%eps_bio = set by gui application
n_bio = (eps_bio)^0.5;

% biosensor base layer permittivity
epsilon(4,:) = ones(1,length(epsilon(1,:)))*(n_bio)^2;
d_analyte = 2*1e-9; %fourth layer thickness (nm)

% biosensor layer permittivity
epsilon(5,:) = ones(1,length(epsilon(1,:)))*(n_bio)^2;
%d_bio = SET BY GUI APPLICATION;%biosensor layer thickness (nm)

% background layer permittivity (water)
epsilon(6,:) = ones(1,length(epsilon(1,:)))*(n_water)^2;

%% n variation on biosensor layer
%biosensor layer varies from water refration index to biosensor refraction index 
n = [n_water,n_bio].^0.5;

%% input layers thicknesses
d(1)= 0;           % not used in the simulation
d(2)= d_ti;        % Titanium adhesion layer thickness (nm)
d(3)= d_au;        % gold layer thickness (nm)
d(4)= d_analyte*0; % pre analyte layer thickness (nm) -> (unused)
d(5)= d_bio;     % biosensor layer thickness (nm)
d(6)= 0;           % not used in the simulation


%% Sweep for lambda and incidence angle*
% Angle sweep limits for SPR curve

theta_deg=(15:.1:90)';

for count_n = 1:length(n);
    %set current biosensor layer permittivity
    epsilon(5,:) = ones(1,length(epsilon(1,:)))*n(count_n)^2;
    
    for count_lambda = 1:length(lambda);
        
        % find the current prism refraction index for current wavelength
        % and correct prism effect on the internal incidence angle:
        
        n_t = SQRTmod(epsilon(:,count_lambda));
        theta_ref=60+asind(1/n_t(1).*sind(theta_deg-60));
        
        %phase thicknesses
        L = d(2:end-1)'.*n_t(2:end-1);
        
        %start angle iteration for TM mode
        for count_theta=1:length(theta_ref);      
            incident_angle = theta_ref(count_theta);
            %calculates reflectivity via transfer matrix with current parameters
            reflectivity =  Gamma_TMM(incident_angle,L,epsilon(:,count_lambda),lambda(count_lambda),'tm');
            RTM(count_theta,count_lambda)=abs(reflectivity).^2; % reflectance coefficient
        end
    end
end
end
%% *Functions * %%
function [e1,e2] = RefractionIndex2Permittivity(n,k)
    % This function converts from complex refraction indexes to complex permittivities
    % reference: maier, Plasmonics: fundamentals and applications chapter 01, pg 10)
    e1 = n.^2-k.^2;
    e2 = 2*k.*n;
end
%%
% Complex permittivity to refractive index conversion conversion

function [n,k] = Permittivity2RefractionIndex(epsilon)
    % This function converts from complex refraction indexes to complex permittivities
    % reference: maier, Plasmonics: fundamentals and applications chapter 01, pg 10)
    e1 = real(epsilon);
    e2 = imag(epsilon);
    n = sqrt(e1./2+1/2*(abs(epsilon)));
    % k = e2/(2n)
    k = e2./(2.*n);
end

function reflectivity = Gamma_TMM(theta,L,epsilon,lambda,polarization)
    
    % This function calculates the reflectivity of a multilayer system via the trasfer matrix method the function takes as input:
    %1) An incindence angle for the impinging light (in degrees).
    %2) A layer width vector for the same layers, from first to last, where  the first and last layers widths'
    % are not used as they are considered of infinite be infinite in this method.
    %3) A complex permittivity vector for the n-layers of the system, from first to last.
    %4) An operating wavelength
    %5) Incident light polarization
    
    %Orfanidis Eletromagnetic Waves an Antennas Chapter 8 section 2 (Lossy multilayer systems)
    
    % refraction for first layer
    %[n,~] = Permittivity2RefractionIndex(epsilon);% calculates refraction index from permittivity
    [n_r,n_i] = Permittivity2RefractionIndex(epsilon);
    n = n_r+j*n_i;
    M = length(n)-2;%number o slabs in the multilayer structure
    
    %complex optical lenghts
    %L = n.*d;
    %cos of angle of incidence (from fresnell eqs)
    %equivalent to: cos_theta_inc = sqrt(1-(sind(theta)./n).^2);
    cos_theta_inc  = SQRTmod(1-(n(1)*sind(theta)./n).^2);
    
    %trasnverse refraction indexes for TM and Te polarizations
    if (polarization == 'te')
        nT = n .* cos_theta_inc;%TE polarization
    else
        nT = n ./ cos_theta_inc;%TM polarization
    end
    
    if M>0
        L = L .* cos_theta_inc(2:M+1);
    end
    
    %calculating rho for the dieletric layers
    rho_ti = (nT(1:M+1)-nT(2:M+2))./(nT(1:M+1)+nT(2:M+2));
    %rho_ti = -diff(nT) ./ (diff(nT) + 2*nT(1:M+1));
    %initializing gamma at the last interface:
    Gamma_Ti = rho_ti(M+1).*ones(1,length(lambda));
    
    %reflection response for the i-th layer of M total layers
    %i = M,M-1,...,1
    for i = M:-1:1
        delta_i = 2*pi*L(i)./lambda;
        Gamma_Ti = (rho_ti(i) + Gamma_Ti.*exp(-j*2*delta_i))./(1+rho_ti(i).*Gamma_Ti.*exp(-j*2*delta_i));
    end
    reflectivity= Gamma_Ti;
end

function  output = SQRTmod(z)
    %Modified square-root function for complex values with small complex
    %part
    %The modification fixes a bug for when Im(z)~ 0, but z =/= 0 which
    %causes for sqrt(-1) = 1 rather than sqrt(-1) = -i .
    output = conj(sqrt(conj(z)));
end
