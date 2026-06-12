%%
% *Surface Plasmon Resonance simulation GUI for multilayer structure at optical frequencies.*
% This code simulates surface plasmon resonance curves for a multilayer system
% containing BK7 glass, Titanium, Gold and an analyte layer via the Transfer-Matrix-Method(TMM).
%
% - BK7 glass layer- ok
%
% - Gold Layer - ok
%
% - Titanium layer - ok
%
% - Biosensor base layer (~3nm- eps ~ 2-3) - ok
%
% - Biosensor layer (~1nm - eps 2-3) - ok
%
% - water background - ok
%
% *Author: Matheus Rotta Ribeiro - 1/22/2023*

function [RTM,theta_ref,theta_deg,epsilon] = SPRgui_func(lambda,d_au,d_ti,n_water,d_bio,eps_bio)
addpath ExperimentalData

%lambda = SET BY GUI APPLICATION
lambda_nm = lambda./1e-9; % nm units
lambda_um = lambda./1e-6; % um units
% do not exceed 400-2000nm range (experimental data limits)

%% *BK7 glass prism, *$\lambda$*= 0.3-2.5 um Schott *
%
% SCHOTT Zemax catalog 2017-01-20b (obtained from http://www.schott.com)

%layer 1: BK7 glass prism
load('NBK7SCHOTT.mat')%BK7 vendor data

%interpolating data to chosen lambda vector:
n_bk7_interp = spline(NBK7SCHOTT.wl_n,NBK7SCHOTT.n,lambda_um)*1.; %real part refractive index - BK7 prism
k_bk7_interp = spline(NBK7SCHOTT.wl_k,NBK7SCHOTT.k,lambda_um)*1.; %imaginary part refractive index - BK7 prism

[e_real,e_img] = RefractionIndex2Permittivity(n_bk7_interp,k_bk7_interp);% convert complex refraction index to complex permittivity

epsilon(1,:)=complex(e_real,e_img)/1; % first layer permittivity constants

%% *Titanium, *$\lambda$*= 0.40 - 10 um Mash*
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

%% *Gold 25 nm, *$\lambda$*= 300- 2000 nm Yakubovsky (very close to 53 nm data)*
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
%n_water = set by gui application
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
d(1)= 0; % not used in the simulation
d(2)= d_ti; % Titanium adhesion layer thickness (nm)
d(3)= d_au; % gold layer thickness (nm)
d(4)= d_analyte*0; % pre analyte layer thickness (nm) -> (unused)
d(5)= d_bio; % biosensor layer thickness (nm)
d(6)= 0; % not used in the simulation

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
reflectivity = Gamma_TMM(incident_angle,L,epsilon(:,count_lambda),lambda(count_lambda),'tm');
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

% This function calculates the reflectivity of a multilayer system via the
% Transfer Matrix Method. Inputs:
%  1) theta       - Incidence angle (degrees)
%  2) L           - Layer phase thicknesses vector
%  3) epsilon     - Complex permittivity vector (N layers)
%  4) lambda      - Operating wavelength (m)
%  5) polarization - 'tm' or 'te'
%
% Reference: Orfanidis, Electromagnetic Waves and Antennas, Ch. 8.2

[n_r,n_i] = Permittivity2RefractionIndex(epsilon);
n = n_r+1j*n_i;
M = length(n)-2; % number of slabs in the multilayer structure
k0 = 2*pi/lambda;

if strcmp(polarization,'tm')
    eta = @(ni,thi) ni.*cos(thi); % TM characteristic admittance
elseif strcmp(polarization,'te')
    eta = @(ni,thi) cos(thi)./ni; % TE
end

% Snell's law propagation through all layers
theta_layer = zeros(length(n),1);
theta_layer(1) = theta*pi/180;
for ii = 2:length(n)
    sintheta = n(1)*sin(theta_layer(1))./n(ii);
    theta_layer(ii) = asin(sintheta);
end

% Build transfer matrix
T = eye(2);
for ii = 2:M+1
    delta = k0*L(ii-1)*cos(theta_layer(ii));
    ni = n(ii); thi = theta_layer(ii);
    etai = eta(ni,thi);
    Mi = [cos(delta), -1j*sin(delta)/etai; -1j*etai*sin(delta), cos(delta)];
    T = T * Mi;
end

eta0 = eta(n(1),theta_layer(1));
etaN = eta(n(end),theta_layer(end));

numerator   = (T(1,1) + T(1,2)*etaN)*eta0 - (T(2,1) + T(2,2)*etaN);
denominator = (T(1,1) + T(1,2)*etaN)*eta0 + (T(2,1) + T(2,2)*etaN);
reflectivity = numerator/denominator;
end

function n_sqrt = SQRTmod(epsilon)
% Returns the complex square root of each element of epsilon,
% choosing the branch with non-negative imaginary part.
n_sqrt = sqrt(epsilon);
neg_imag = imag(n_sqrt) < 0;
n_sqrt(neg_imag) = conj(n_sqrt(neg_imag));
end
