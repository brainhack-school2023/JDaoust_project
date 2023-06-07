In this directory, dataset of the session #1 for one participant were convert into BIDS format. 

The Nifti files in this directory were copy-paste from Alliance Canada server into this project and rename to fit the BIDS format (i.e.: convertion of the Nifti files with dcm2niix were not in 4D). This Nifti files were convert with MRIConvert and we used fslswapdim -x -y z to reorient images. 

The Json files in this directory came from the convertion with dcm2niix.

WARNING: Mismatch between the Json files (TR: 2.75sec) and the Nifti files (TR: 0.0sec) were fixed using jupiter notebook script (see: Fix_TRmismatch_BIDS.ipynb)  
