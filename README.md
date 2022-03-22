# OCT-A-ANALYSIS

I. General description:

OCT-A ANALYSIS is a macro that automates operations in ImageJ used to analyze OCT-A angiograms. This program is especially useful for case series studies. It automates the analysis of OCT-A. 
➔Accelerate data collection 
➔Improve the reproducibility of results
The program is currently intended to process grayscale angiograms with a resolution of 320*320pixels. Otherwise the measurements of the ZAC will be erroneous.
Other resolutions will be supported in the next update.

II. Files needed:

1. ImageJ software
Link: https://imagej.nih.gov/ij/download.html
NB: The ImageJ software is directly executable, no installation required. Just download the file and unzip it.

2. The macro + 3 plugins
Link: https://mega.nz/folder/Gk0l0CgK#2BBm3JJqhuJWFfBmtUDRrg
      o OCT-A ANALYSIS.ijm (version 1.0.0)
      o FeatureJ_.jar (version 2.0.0)
      o imagescience.jar (version 3.0.0)
      o MorphoLibJ_-1.4.0.jar (version 1. 4.0)

These plugins must be installed in the ImageJ software by copying the files to ..\ImageJ\plugins (See video).
The macro must be installed from the ImageJ software using the command: Plugins > Macros > Install (See video).

III. Tutorial

• Import the grayscale angiogram
• Select the size of the field of vision: 3-3mm, 4.5-4.5mm, 6-6mm or 9-9mm
• Manually trace the central avascular zone ➔ The program automatically measures the following parameters: Area, Perimeter and Circularity of the FAZ
• The program measures the intensity of the signal in the ZAC which can be considered as noise ➔ In the measurement of vascular densities you have the choice to take this parameter into consideration to control it (cancel the noise differences between the acquisitions/patients).
• The vascular densities are measured at the level of the EXTTRAFOVEAL microcirculation:

    o Vascular density without any filter or thresholding
    o Vascular skeleton density without any filter or thresholding
    o Vascular density after thresholding by the “Mean” method
    o Vascular density after thresholding by the “Huang” method
    o Vascular density after Hessian filter + double thresholding (Multilevel: “Mean” + “Huang”)
    o Vascular skeleton density after Hessian filter + double thresholding (Multilevel:“Mean” + “Huang”) + skeletonization

All measured vascular densities represent the area of the white pixels reported to the area of the angiogram after EXCLUSION of the ZAC ➔ The results will be independent of the size ofthe FAZ

• For each angiogram processed, an OUTPUT folder is created at the location of the image and contains:

    o FAZoutline: angiogram with plotted FAZ and area, perimeter and circularity values
    o VAD Without Threshold: binarized angiogram without thresholding
    o VSD Without Threshold: binarized and skeletonized angiogram without thresholding
    o VAD Huang: binarized angiogram + Huang thresholding
    o VAD Mean: binarized angiogram + Mean thresholding
    o VAD Multilevel: binarized angiogram + Multilevel thresholding
    o VSD Multilevel: binarized + skeletonized angiogram + Multilevel thresholdingo FAZ biomarkers: Excel file containing the results of the FAZ
    o PERFUSION biomarkers: Excel file containing vascular density measurements
    o FAZ.roi: a memory of the manual tracing in order to have it on hand when you need it (prospective study )

• Tutorial video: In the downloaded folder.

IV. Bibliographic references on “image processing”    ==> In OCT-A ANALYSIS GUIDE.PDF 

V. COMING SOON

• Support for different resolutions
• Automatic tracing of the FAZ
• Other FAZ biomarkers : FAZ axis
• Other perfusion biomarkers: extrafoveal avascular area, lacunarity/fractal dimension
• Choriocapillaris analysis: flow density, fractal dimension, flow voids (count, total area, %area..)

VI. Contact: ayedi.omar@outlook.com

• For any suggestion
• For script modifications so it suits to your study/methodology
