/*
 * This script implements the wavelength to RGB conversion
 * illustrated at http://www.physics.sfasu.edu/astro/color/spectra.html
 * by linear approximation of the curves.
 * Set WL_ini and WL_step according to the initial wavelength and the 
 * wavelength resolution in nm, respectively.
 */
function setLUTByWavelength(wavelength) {
	// These values will be between 0 and 1
	red = green = blue = 0;

	if (wavelength < 380 || wavelength > 780)
		abort("Only wavelengths between 380 and 780 are supported");
	else if (wavelength <= 440) {
		red = (440 - wavelength) / (440 - 380);
		blue = 1;
	}
	else if (wavelength <= 490) {
		green = (wavelength - 440) / (490 - 440);
		blue = 1;
	}
	else if (wavelength <= 510) {
		green = 1;
		blue = (510 - wavelength) / (510 - 490);
	}
	else if (wavelength <= 580) {
		red = (wavelength - 510) / (580 - 510);
		green = 1;
	}
	else if (wavelength <= 645) {
		red = 1;
		green = (645 - wavelength) / (645 - 580);
	}
	else
		red = 1;

	intensity = 1;
	if (wavelength > 700)
		intensity = 0.3 + 0.7 * (780 - wavelength) / (780 - 700);
	else if (wavelength < 420)
		intensity = 0.3 + 0.7 * (wavelength - 380) / (420 - 380);

	red *= intensity;
	green *= intensity;
	blue *= intensity;

	print(red+" "+green+" "+blue);
	// assuming gamma == 1
	// setForegroundColor(red * 255, green * 255, blue * 255);
	reds = newArray(256); 
    greens = newArray(256); 
    blues = newArray(256);
    
    for (i=0; i<256; i++) {
        reds[i] = round(i*red);
        greens[i] = round(i*green);
        blues[i] = round(i*blue);
    }
    setLut(reds, greens, blues);
}

for (i = 1; i <= nSlices; i++) {
    setSlice(i);
    WL_init = 450; // Initial wavelength
    WL_step = 2;   // wavelength step
    wavelength = WL_ini+(i-1)*WL_step;
	setLUTByWavelength(wavelength);
}
