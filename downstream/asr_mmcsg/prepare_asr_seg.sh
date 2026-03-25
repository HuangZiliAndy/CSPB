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

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF0,2
output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_mmcsg/MDM_BF0,2

for split in dev eval train; do
  python downstream/asr_mmcsg/prepare_asr_seg.py \
      ${input_dir}/${split} \
      ${output_dir}/${split} \
      --min_dur $min_dur --max_dur $max_dur
  python3 downstream/asr_mmcsg/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF0,2,3,4
output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_mmcsg/MDM_BF0,2,3,4

for split in dev eval train; do
  python downstream/asr_mmcsg/prepare_asr_seg.py \
      ${input_dir}/${split} \
      ${output_dir}/${split} \
      --min_dur $min_dur --max_dur $max_dur
  python3 downstream/asr_mmcsg/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF
output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_mmcsg/MDM_BF

for split in dev eval train; do
  python downstream/asr_mmcsg/prepare_asr_seg.py \
      ${input_dir}/${split} \
      ${output_dir}/${split} \
      --min_dur $min_dur --max_dur $max_dur
  python3 downstream/asr_mmcsg/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
done
