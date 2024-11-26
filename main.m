A = importdata('ASTMG173.csv',',');
data = A.data;
wavelength = data(:,1); %in nm
%col. 2, ETR is for space usage
%col. 3, global is for terrestrial use
%col. 4, dir + circum is used when you concentrate the sunlight.
globalSPECIRR = data(:,3); %in W*M^-2*nm^-1

%anatase band gap = 3.2eV
%calculate max wavelength for anatase
lambdaAnatase = ((4.135667696*10^-15)*(3*10^8)/3.2)*10^9; %in nm

ind = wavelength < lambdaAnatase;
lambdaABSana = wavelength(ind);
globABSana = globalSPECIRR(ind);

anataseE = cumtrapz(lambdaABSana, globABSana);
totalE = cumtrapz(wavelength, globalSPECIRR);

anataseFrac = anataseE(end)/totalE(end);

hold on
figure(1)
plot(wavelength, globalSPECIRR, 'k')
xlabel('Wavelength (nm)')
ylabel('Spectral Irradiance (Wm^-^2nm^-^1)')
hold off

hold on
area(lambdaABSana, globABSana)
colororder("#7E2F8E")
legend('', 'Light Absorbed by Anatase')
txt = ['Anatase absorption: ' num2str(anataseFrac*100) '%'];
text(2350,1.58,txt)
title('Standard Terrestrial Solar Spectra')
hold off

f = gcf;
exportgraphics(f, 'ANATASEonlyabsgraph.png','Resolution',450);

%new wavelength for AgNPs, with any wavelength greater than 800nm being blocked off, excluding wavelengths absorbed by anatase.
ind2 = (lambdaAnatase < wavelength) & (wavelength < 800);
lambdaABSag = wavelength(ind2);
globABSag = globalSPECIRR(ind2);

agE = cumtrapz(lambdaABSag, globABSag);
agFrac = (agE(end)/totalE(end)) + anataseFrac;

hold on
figure(2)
plot(wavelength, globalSPECIRR, 'k')
xlabel('Wavelength (nm)')
ylabel('Spectral Irradiance (Wm^-^2nm^-^1)')
txt1 = {['AgNP absorption: ' num2str(agFrac*100) '%'], ['Anatase absorption: ' num2str(anataseFrac*100) '%']};
text(2350,1.45,txt1)
hold off

hold on
aga = area(lambdaABSag, globABSag);
anata = area(lambdaABSana, globABSana);
anata.FaceColor = "#7E2F8E";
aga.FaceColor = "#D95319";
legend('', 'Light Absorbed by AgNP', 'Light Absorbed by Anatase and AgNP')
title('Standard Terrestrial Solar Spectra')
hold off
f = gcf;
exportgraphics(f, 'ANATASE_Ag_absgraph.png','Resolution',450);

%difference in absorption percent of total light:
fprintf('difference in absorption percent of total light: %.2f', (agFrac - anataseFrac)*100)