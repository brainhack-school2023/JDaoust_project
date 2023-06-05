#!/bin/bash
#SBATCH --account=def-amichaud
#SBATCH --nodes=1
#SBATCH --mem=100      # memory; default unit is megabytes
#SBATCH --time=0-00:05           # time (DD-HH:MM)
#SBATCH --job-name="BIDS_convert"

INPDIR=../data/RND047/DICOM/
OUTDIR=../data/BIDS_data

dcm2niix -o $OUTDIR -b y -z y -v y -f sub-%i_%p $INPDIR
