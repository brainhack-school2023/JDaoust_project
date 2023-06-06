In this directory, dataset of the session of one participant were standardize into BIDS format. 

The nifti files in this directory were copy from Alliance Canada server to this project and rename to fit the BIDS format (i.e.: converted nifti files from dcm2niix were not in 4D). 
The json files in this directory came from the DICOM convertion with dcm2niix.

WARNING: Mismatch between the json files (TR: 2.75sec) and the nifti files (TR: 0.0sec) were fixed using jupiter notebook script (see: Fix_TRmismatch_BIDS.ipynb)  
