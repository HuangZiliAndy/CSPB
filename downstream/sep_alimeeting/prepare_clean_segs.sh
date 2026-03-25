#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=15360
#SBATCH --job-name=prepare_clean_segs
#SBATCH --time=3-00:00:00
#SBATCH --gpus=1

source path.sh

SDM1_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/SDM1
IHM_CLEAN_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting/IHM_CLEAN
ALM_dir=/export/c02/hzili1/datasets/Alimeeting

# create clean segments
for split in Train Test Eval; do
  sdm1_dir=${SDM1_dir}/${split}
  output_dir=${IHM_CLEAN_dir}/${split}
  near_audio_dir=${ALM_dir}/${split}_Ali/${split}_Ali_near/audio_dir
  far_text_dir=${ALM_dir}/${split}_Ali/${split}_Ali_far/textgrid_dir
  #python3 downstream/sep_alimeeting/prepare_clean_segs.py ${sdm1_dir} ${output_dir} ${near_audio_dir} ${far_text_dir}
  python3 downstream/sep_ami/filter_utt.py ${output_dir} ${output_dir}_filter --min_dur 2.0
done
