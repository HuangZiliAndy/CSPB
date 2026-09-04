#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8

# Simulates 2-speaker reverberant mixtures + diffuse WHAM noise for the sep_ami
# downstream task, by combining:
#   - clean speech segments from prepare_clean_segs.sh (IHM_CLEAN_dir)
#   - multi-channel RIRs from gen_rir.sh (RIR_dir)
#   - WHAM noise (wham_noise_dir)
# via downstream/sep_ami/simu_mch_data.py, once per split (dev/test/train).
# Output goes to output_dir/<split>/{wav,metadata,wav.scp,reco2dur,utt2spk}.

source path.sh

wham_noise_dir=/export/c02/hzili1/datasets/wham_noise

# Base directory of the simulated RIRs (subfolders dev/test/train), from downstream/sep_ami/gen_rir.sh
RIR_dir=downstream/sep_ami/AMI_RIRs_3srcs
#./downstream/sep_ami/gen_rir.sh $RIR_dir

SDM1_dir=/export/c02/hzili1/datasets/s3prl_csp/data/AMI/SDM1
IHM_CLEAN_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_ami/IHM_CLEAN
annotations=/export/corpora5/amicorpus/ami_public_manual_1.6.2
#./downstream/sep_ami/prepare_clean_segs.sh $SDM1_dir $IHM_CLEAN_dir $annotations

output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_ami/2spk_reverb_diffuse/MDM

for split in dev test train; do
  data_dir="${IHM_CLEAN_dir}/${split}_filter"
  # NOTE: must derive a fresh per-split path here rather than reassigning RIR_dir itself,
  # otherwise it accumulates across loop iterations (e.g. .../dev/test/train on the 3rd pass).
  RIR_dir_split="${RIR_dir}/${split}"
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

  if [ "$split" == "train" ]; then
    noise_scp_file="${wham_noise_dir}/tr.scp"
    num_utts=20000
  fi
  if [ "$split" == "dev" ]; then
    noise_scp_file="${wham_noise_dir}/cv.scp"
    num_utts=1000
  fi
  if [ "$split" == "test" ]; then
    noise_scp_file="${wham_noise_dir}/tt.scp"
    num_utts=1000
  fi

  python downstream/sep_ami/simu_mch_data.py \
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
