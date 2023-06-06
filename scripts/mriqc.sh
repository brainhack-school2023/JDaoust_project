#!/bin/bash

#User inputs:
bids_root_dir=$HOME/JDaoust_project/data/raw_BIDS_fixed
subj=RND050
nthreads=2
mem=10 #gb
container=docker #docker or singularity

#Make mriqc directory and participant directory in derivatives folder
if [ ! -d $bids_root_dir/derivatives/mriqc ]; then
mkdir $bids_root_dir/derivatives/mriqc
fi

if [ ! -d $bids_root_dir/derivatives/mriqc/sub-${subj} ]; then
mkdir $bids_root_dir/derivatives/mriqc/sub-${subj}
fi

#Run MRIQC
echo ""
echo "Running MRIQC on participant $s"
echo ""

if [ $container == singularity ]; then
  unset PYTHONPATH; singularity run $HOME/mriqc_0.15.1.simg \
  $bids_root_dir $bids_root_dir/derivatives/mriqc/sub-${subj} \
  participant \
  --n_proc $nthreads \
  --hmc-fsl \
  --correct-slice-timing \
  --mem_gb $mem \
  --float32 \
  --ants-nthreads $nthreads \
  -w $bids_root_dir/derivatives/mriqc/sub-${subj}
else
  docker run -it --rm -v $bids_root_dir:/data:ro -v $bids_root_dir/derivatives/mriqc/sub-${subj}:/out \
  poldracklab/mriqc:0.15.1 /data /out \
  participant \
  --n_proc $nthreads \
  --hmc-fsl \
  --correct-slice-timing \
  --mem_gb $mem \
  --float32 \
  --ants-nthreads $nthreads \
  -w $bids_root_dir/derivatives/mriqc/sub-${subj}
fi
