#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=15360
#SBATCH --job-name=prepare_asr_seg
#SBATCH --time=1-00:00:00
#SBATCH --exclude=c04

source path.sh

min_dur=0.0
max_dur=10000.0

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/SDM1
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/SDM1
#
#for split in Eval Test Train; do
#  python3 downstream/asr_alimeeting/prepare_asr_seg.py \
#      ${input_dir}/${split} \
#      ${output_dir}/${split} \
#      --min_dur $min_dur --max_dur $max_dur
#  python3 downstream/asr_alimeeting/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/MDM_BF0,4
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/MDM_BF0,4
#
#for split in Eval Test Train; do
#  python3 downstream/asr_alimeeting/prepare_asr_seg.py \
#      ${input_dir}/${split} \
#      ${output_dir}/${split} \
#      --min_dur $min_dur --max_dur $max_dur
#  python3 downstream/asr_alimeeting/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done
#
#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/MDM_BF0,2,4,6
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/MDM_BF0,2,4,6
#
#for split in Eval Test Train; do
#  python3 downstream/asr_alimeeting/prepare_asr_seg.py \
#      ${input_dir}/${split} \
#      ${output_dir}/${split} \
#      --min_dur $min_dur --max_dur $max_dur
#  python3 downstream/asr_alimeeting/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/MDM
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/MDM
#
#for split in Eval Test Train; do
#  python3 downstream/asr_alimeeting/prepare_asr_seg.py \
#      ${input_dir}/${split} \
#      ${output_dir}/${split} \
#      --min_dur $min_dur --max_dur $max_dur
#  python3 downstream/asr_alimeeting/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/MDM_BF
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/MDM_BF

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/sep_cfg0_SoudenMVDR_2CH
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/sep_cfg0_SoudenMVDR_2CH

for split in Eval Test Train; do
  python3 downstream/asr_alimeeting/prepare_asr_seg.py \
      ${input_dir}/${split} \
      ${output_dir}/${split} \
      --min_dur $min_dur --max_dur $max_dur
  python3 downstream/asr_alimeeting/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/sep_cfg0_SoudenMVDR_4CH
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/sep_cfg0_SoudenMVDR_4CH

for split in Eval Test Train; do
  python3 downstream/asr_alimeeting/prepare_asr_seg.py \
      ${input_dir}/${split} \
      ${output_dir}/${split} \
      --min_dur $min_dur --max_dur $max_dur
  python3 downstream/asr_alimeeting/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/sep_cfg0_SoudenMVDR_8CH
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/asr_alimeeting/sep_cfg0_SoudenMVDR_8CH

for split in Eval Test Train; do
  python3 downstream/asr_alimeeting/prepare_asr_seg.py \
      ${input_dir}/${split} \
      ${output_dir}/${split} \
      --min_dur $min_dur --max_dur $max_dur
  python3 downstream/asr_alimeeting/filter_utt.py ${output_dir}/${split} ${output_dir}/${split}_filter
done
