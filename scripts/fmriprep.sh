#!/bin/bash

#User inputs:
bids_root_dir=$HOME/JDaoust_project/data/BIDS
subj=RND050
nthreads=4
mem=20 #gb
container=docker #docker or singularity

#This script was writting to be use locally 
#This script convert BIDS format dataset to preprocessed data

#Convert virtual memory from gb to mb
mem=`echo "${mem//[!0-9]/}"` #remove gb at end
mem_mb=`echo $(((mem*1000)-5000))` #reduce some memory for buffer space during pre-processing

#export TEMPLATEFLOW_HOME=$HOME/templateflow
export FS_LICENSE=$HOME/JDaoust_project/derivatives/license.txt

#Run fmriprep
if [ $container == singularity ]; then
  unset PYTHONPATH; singularity run -B $HOME/.cache/templateflow:/opt/templateflow $HOME/fmriprep.simg \
    $bids_root_dir $bids_root_dir/../fmriprep \
    participant \
    --participant-label $subj \
    --skip-bids-validation \
    --md-only-boilerplate \
    --fs-license-file $FREESURFER_HOME/license.txt \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym:res-2 \
    --nthreads $nthreads \
    --stop-on-first-crash \
    --mem_mb $mem_mb \
    -w $HOME
else
  cd $HOME
  fmriprep-docker $bids_root_dir $bids_root_dir/../fmriprep \
    participant \
    --participant-label $subj \
    --skip-bids-validation \
    --md-only-boilerplate \
    --fs-license-file $HOME/JDaoust_project/derivatives/license.txt \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym:res-2 \
    --nthreads $nthreads \
    --stop-on-first-crash \
    --mem_mb $mem_mb \
    -w $HOME
fi
