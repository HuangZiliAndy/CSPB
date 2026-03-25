#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=15360
#SBATCH --job-name=prepare_diar_seg
#SBATCH --time=1-00:00:00
#SBATCH --exclude=c04

export PATH="/export/c02/hzili1/tmp/home/hzili1/anaconda3/envs/csp/bin:$PATH"

for dset in MDM_BF MDM_BF0,2,4,6 MDM_BF0,3 SDM1 MDM; do
  input_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/Dipco/${dset}
  output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/diar_dipco/${dset}
  
  for split in dev eval train; do
    python3 downstream/diar_dipco/prepare_diar_seg.py \
  	--normalize 1 \
  	--chunk_size 10.0 \
  	--stride_size 5.0 \
  	${input_dir}/${split} \
  	${output_dir}/${split}
    python3 downstream/diar_dipco/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
  done
done
