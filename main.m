%antase band gap = 3.2eV
A = importdata('ASTMG173.csv',',');
data = A.data;
wavelength = data(:,1); %in nm
%col. 2, ETR is for space usage
%col. 3, golbal is for terrestrial use
%col. 4, dir + circum is used when you concentrate the sunlight.
globalSPECIRR = data(:,3); %in W*M^-2*nm^-1

%calculate max wavelength for antase
lamdaAntase = ((4.135667696*10^-15)*(3*10^8)/3.2)*10^9; %in nm

ind = wavelength < lamdaAntase;
lamdaABS = wavelength(ind);
globABS = globalSPECIRR(ind);


hold on
figure(1)
title('Standard Terrestrial Solar Spectra')
plot(wavelength, globalSPECIRR, 'k')
xlabel('Wavelength (nm)')
ylabel('Spectral Irradiance (Wm^-^2nm^-^1)')
area(lamdaABS, globABS)
colororder("#7E2F8E")
legend('', 'Light Absorbed by Antase')
hold off

f = gcf;
exportgraphics(f, 'ANTASEonlyabsgraph.png','Resolution',450);