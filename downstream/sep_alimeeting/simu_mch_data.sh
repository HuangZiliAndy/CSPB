#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=15360
#SBATCH --job-name=simu_sep_data
#SBATCH --time=3-00:00:00
#SBATCH --gpus=1

source path.sh

wham_noise_dir=/export/c02/hzili1/datasets/wham_noise

RIR_dir=downstream/sep_alimeeting/ALM_RIRs_3srcs
#./downstream/sep_alimeeting/gen_rir.sh $RIR_dir

IHM_CLEAN_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting/IHM_CLEAN
#./downstream/sep_alimeeting/prepare_clean_segs.sh

output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting/2spk_reverb_diffuse/MDM

for split in Eval Test Train; do
  data_dir="${IHM_CLEAN_dir}/${split}_filter"
  num_spk=2
  num_spk_prob=1.0
  add_noise=1
  add_reverb=1
  sir_range="5,-5"
  snr_range="5,20"
  normalize=1
  s1_first=0
  s1_only=0
  full_overlap=0
  seed=7
  noise_type="diffuse"
  single_channel=0
  output_dir_split="${output_dir}/${split}"

  if [ "$split" == "Train" ]; then
    noise_scp_file="${wham_noise_dir}/tr.scp"
    num_utts=20000
    RIR_dir_split="${RIR_dir}/train"
  fi
  if [ "$split" == "Eval" ]; then
    noise_scp_file="${wham_noise_dir}/cv.scp"
    num_utts=1000
    RIR_dir_split="${RIR_dir}/dev"
  fi
  if [ "$split" == "Test" ]; then
    noise_scp_file="${wham_noise_dir}/tt.scp"
    num_utts=1000
    RIR_dir_split="${RIR_dir}/test"
  fi

  python3 downstream/sep_alimeeting/simu_mch_data.py \
	  $data_dir \
	  $output_dir_split \
	  --noise_scp_file $noise_scp_file \
	  --RIR_dir $RIR_dir_split \
	  --num_spk $num_spk \
	  --num_spk_prob $num_spk_prob \
	  --add_noise $add_noise \
	  --noise_type $noise_type \
	  --add_reverb $add_reverb \
	  --sir_range $sir_range \
	  --snr_range $snr_range \
	  --num_utts $num_utts \
	  --normalize $normalize \
	  --s1_first $s1_first \
	  --s1_only $s1_only \
	  --full_overlap $full_overlap \
	  --single_channel $single_channel \
	  --seed $seed
done
