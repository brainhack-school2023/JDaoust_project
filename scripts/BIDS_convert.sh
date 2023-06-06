#!/bin/bash
#SBATCH --account=def-amichaud
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=0-00:16           # time (DD-HH:MM)
#SBATCH --job-name="BIDS convert"

#This script were writting to use on Alliance Canada. 
#This script convert all raw files from data/raw/* to nifti or json with dcm2niix and rename files to fit with BIDS format.
#Bold nifti files were copy-paste from our project directory backup to this project and rename to fit with BIDS format

module load dcm2niix


for file in ../data/raw/*; do  #find the session number
  name=$(echo $file| cut  -d'/' -f 4)
  if [[ ${name:6} = 'flw24' ]]; then
    session=4
  elif [[ ${name:6} = 'flw12' ]]; then
    session=3
  elif [[ ${name:6} = 'flw2' && ${name::3} = 'RGC' ]]; then  #RGC's participant had a different timeline
    session=x
  elif [[ ${name:6} = '' ]]; then 
    session=1
  else session=2
  fi
  cd $HOME
  mkdir JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/{anat,func} -p
  dcm2niix -o ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/ -b y -m y -z y -f %i_%s_%p ~/JDaoust_project/data/raw/${name}/DICOM/
  
  #T1w
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*T1W*_orient.nii.gz ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/anat/sub-${name::6}_ses-${session}_T1w.nii.gz
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*T1W*_orient.nii ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/anat/sub-${name::6}_ses-${session}_T1w.nii
  gzip ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/anat/sub-${name::6}_ses-${session}_T1w.nii
  mv ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/*T1W*.json ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/anat/sub-${name::6}_ses-${session}_T1w.json
  
  #BDM-run1
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*FOOD1_orient_cut.nii.gz ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-1_bold.nii.gz
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*FOOD1_orient_cut.nii ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-1_bold.nii
  gzip ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-1_bold.nii
  mv ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/*FOOD1*.json ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-1_bold.json
  
  #BDM-run2
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*FOOD2_orient_cut.nii.gz ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-2_bold.nii.gz
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*FOOD2_orient_cut.nii ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-2_bold.nii
  gzip ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-2_bold.nii
  mv ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/*FOOD2*.json ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-2_bold.json
  
  #BDM-run3
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*FOOD3_orient_cut.nii.gz ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-3_bold.nii.gz
  scp ~/projects/def-amichaud/share/dagher6_back_up/raw/${name}/DICOM/mcverter/*FOOD3_orient_cut.nii ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-3_bold.nii
  gzip ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-3_bold.nii
  mv ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/*FOOD3*.json ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-3_bold.json
  
  sed -i '$s/}/,\n"TaskName":"BDM"}/' ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run*.json
  #jq 'del(.ImageOrientationPatientDICOM)' ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run*.json
  #jq 'del(.ImageOrientationPatientDICOM)' ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/anat/sub-${name::6}_ses-${session}_T1w.json

  rm ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/GUT*
  rm ~/JDaoust_project/data/BIDS/sub-${name::6}/ses-${session}/gut*
  
  for run in 1 2 3; do
     paste ~/projects/def-amichaud/share/dagher6_back_up/EVs/bariatric_${name::6}_session${session}_run${run}_img_onset*.txt ~/projects/def-amichaud/share/dagher6_back_up/EVs/bariatric_${name::6}_session${session}_run${run}_img_duration*.txt ~/projects/def-amichaud/share/dagher6_back_up/EVs/bariatric_${name::6}_session${session}_run${run}_img_bids*.txt > ~/JDaoust_project/data/raw_BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-${run}_events.tsv

  sed -i '1i \onset \tduration \tbids' ~/JDaoust_project/data/raw_BIDS/sub-${name::6}/ses-${session}/func/sub-${name::6}_ses-${session}_task-BDM_run-${run}_events.tsv

  done

done 

 
