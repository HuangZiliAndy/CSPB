#!/bin/bash
#
# prepare_asr_seg.sh — Prepare per-utterance ASR data directories for the DiPCo corpus.
#
# This script runs in two stages for each recording condition:
#
#   Stage 1 — downstream/asr_ami/prepare_asr_seg.py
#     Reads recording-level Kaldi data directories (produced by data_prep/prepare_dipco.sh)
#     and cuts each recording into individual utterance WAV files using the segments file.
#     Writes wav.scp, text, utt2spk, reco2dur, and utt2num_samples for each split.
#
#   Stage 2 — downstream/asr_ami/filter_utt.py
#     Filters utterances by duration (default: 0.1 s – 20.0 s) for the dev and eval splits,
#     writing *_filter directories that are used directly by the training script.
#
# Note: DiPCo has no training set. The dev split is used for fine-tuning and eval for testing.
#       Both are filtered; the unfiltered eval split is kept as the test reference.
#
# Prerequisites:
#   Run data_prep/prepare_dipco.sh first to populate the input Kaldi data directories.
#
# Usage:
#   bash downstream/asr_dipco/prepare_asr_seg.sh

source path.sh

# Root directory containing the Kaldi data directories produced by prepare_dipco.sh
# Expected structure: ${dipco_data_dir}/${cond}/{dev,eval}/
dipco_data_dir=/path/to/data/DiPCo

# Root output directory for the segmented ASR data
# Outputs will be written to: ${output_base_dir}/${cond}/{dev,eval}/
#                          and ${output_base_dir}/${cond}/{dev_filter,eval_filter}/
output_base_dir=/path/to/downstream/asr_dipco

# Utterances outside [min_dur, max_dur] are excluded by prepare_asr_seg.py.
# Set wide bounds here to keep all segments; let filter_utt.py apply the training filter.
min_dur=0.0
max_dur=10000.0

# Recording conditions to process. Examples:
#   SDM1 — Single Distant Microphone (mono)
#   MDM  — Multiple Distant Microphones (multi-channel)
for cond in SDM1 MDM; do
  input_dir=${dipco_data_dir}/${cond}
  output_dir=${output_base_dir}/${cond}

  # Stage 1: cut recordings into per-utterance WAV files
  for split in dev eval; do
    python3 downstream/asr_ami/prepare_asr_seg.py \
        ${input_dir}/${split} \
        ${output_dir}/${split} \
        --min_dur ${min_dur} \
        --max_dur ${max_dur}
  done

  # Stage 2: apply duration filtering to dev and eval
  # filter_utt.py defaults: --min_dur 0.1 --max_dur 20.0
  python3 downstream/asr_ami/filter_utt.py ${output_dir}/dev  ${output_dir}/dev_filter
  python3 downstream/asr_ami/filter_utt.py ${output_dir}/eval ${output_dir}/eval_filter
done
