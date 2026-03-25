#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=15360
#SBATCH --job-name=prepare_asr_seg
#SBATCH --time=1-00:00:00

source path.sh

min_dur=0.0
max_dur=10000.0

#for cond in SDM1 MDM_BF0,3 MDM_BF0,2,4,6 MDM_BF; do
for cond in MDM; do
  input_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/Dipco/${cond}
  output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/asr_dipco/${cond}

  mkdir -p ${output_dir}
  
  for split in dev eval; do
    python downstream/asr_dipco/prepare_asr_seg.py \
        ${input_dir}/${split} \
        ${output_dir}/${split} \
        --min_dur $min_dur --max_dur $max_dur
    python3 downstream/asr_dipco/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
  done
done
