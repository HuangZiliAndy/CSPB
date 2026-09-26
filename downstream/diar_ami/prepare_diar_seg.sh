#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=15360
#SBATCH --job-name=prepare_asr_seg
#SBATCH --time=1-00:00:00
#SBATCH --exclude=c04,octopod
#
# prepare_diar_seg.sh — Prepare chunked diarization data directories for the AMI corpus.
#
# For each recording condition and split:
#   1. downstream/diar_ami/prepare_diar_seg.py cuts each recording into 10 s chunks (no overlap)
#      and writes a per-chunk RTTM (from rttm.scp).
#   2. downstream/diar_ami/filter_seg.py keeps chunks with at most 4 speakers, writing
#      *_filter directories that are used by train_scripts/diar_*.sh.
#
# Prerequisites:
#   Run data_prep/prepare_ami.sh first to populate the input Kaldi data directories.
#
# Usage:
#   bash downstream/diar_ami/prepare_diar_seg.sh

source path.sh

# Root directory containing the Kaldi data directories produced by prepare_ami.sh
# Expected structure: ${ami_data_dir}/${cond}/{dev,test,train}/
ami_data_dir=/path/to/data/AMI

# Root output directory for the chunked diarization data
# Outputs will be written to: ${output_base_dir}/${cond}/{dev,test,train}/ and *_filter/
output_base_dir=/path/to/downstream/diar_ami

# Recording conditions to process. Examples:
#   SDM1 — Single Distant Microphone (mono)
#   MDM  — Multiple Distant Microphones (multi-channel)
for cond in SDM1 MDM; do
  input_dir=${ami_data_dir}/${cond}
  output_dir=${output_base_dir}/${cond}

  for split in dev test train; do
    python3 downstream/diar_ami/prepare_diar_seg.py \
	--normalize 1 \
	${input_dir}/${split} \
	${output_dir}/${split}
    python3 downstream/diar_ami/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
  done
done
