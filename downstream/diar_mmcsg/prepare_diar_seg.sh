#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=15360
#SBATCH --job-name=prepare_diar_seg
#SBATCH --time=1-00:00:00
#SBATCH --exclude=c04
#
# prepare_diar_seg.sh — Prepare chunked diarization data directories for the MMCSG corpus.
#
# For each recording condition and split:
#   1. downstream/diar_mmcsg/prepare_diar_seg.py cuts each recording into 10 s chunks with a 5 s stride
#      and writes a per-chunk RTTM (from rttm.scp).
#   2. downstream/diar_mmcsg/filter_seg.py keeps chunks with at most 4 speakers, writing
#      *_filter directories that are used by train_scripts/diar_*.sh.
#
# Prerequisites:
#   Run data_prep/prepare_mmcsg.sh first to populate the input Kaldi data directories.
#
# Usage:
#   bash downstream/diar_mmcsg/prepare_diar_seg.sh

source path.sh

# Root directory containing the Kaldi data directories produced by prepare_mmcsg.sh
# Expected structure: ${mmcsg_data_dir}/${cond}/{dev,eval,train}/
mmcsg_data_dir=/path/to/data/MMCSG

# Root output directory for the chunked diarization data
# Outputs will be written to: ${output_base_dir}/${cond}/{dev,eval,train}/ and *_filter/
output_base_dir=/path/to/downstream/diar_mmcsg

# Recording conditions to process. Examples:
#   SDM1 — Single Distant Microphone (mono)
#   MDM  — Multiple Distant Microphones (multi-channel)
for cond in SDM1 MDM; do
  input_dir=${mmcsg_data_dir}/${cond}
  output_dir=${output_base_dir}/${cond}

  for split in dev eval train; do
    python3 downstream/diar_mmcsg/prepare_diar_seg.py \
	--normalize 1 \
	--chunk_size 10.0 \
	--stride_size 5.0 \
	${input_dir}/${split} \
	${output_dir}/${split}
    python3 downstream/diar_mmcsg/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
  done
done
