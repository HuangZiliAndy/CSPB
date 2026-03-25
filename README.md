# CSPB: Conversational Speech Processing Benchmark

CSPB is a benchmark for evaluating self-supervised speech models on conversational speech tasks.
It supports four meeting corpora and three downstream tasks, built on top of the
[s3prl](https://github.com/s3prl/s3prl) toolkit.

## Supported Datasets and Tasks

| Dataset | ASR | Diarization | SE / SS |
|---------|:---:|:-----------:|:-------:|
| AMI | ✓ | ✓ | ✓ |
| AliMeeting | ✓ | ✓ | ✓ |
| MMCSG | ✓ | ✓ | |
| DiPCo | ✓ | | |

## Prerequisites

- **s3prl**: clone and install from [s3prl/s3prl](https://github.com/s3prl/s3prl).
  All scripts assume they are run from the s3prl root directory (where `run_downstream.py` lives).
- **ESPnet** (ASR scoring and SE/SS evaluation): required for `downstream/asr_ami/score.sh`
  and the SE/SS inference pipeline.
- **BeamformIt** (optional, MDM beamforming): set `BEAMFORMIT` in `path.sh`.
- Python packages: `soundfile`, `editdistance`, `fairseq`, `tqdm`.

## Configuration

Edit `path.sh` at the repo root to set your Python environment and tool paths:

```bash
# path.sh
export PATH="/path/to/your/conda/env/bin:$PATH"
export BEAMFORMIT=/path/to/BeamformIt        # only needed for beamforming
export PATH="${PATH}:${BEAMFORMIT}"
```

---

## Step 1: Prepare Dataset in Kaldi Format

Each script reads the raw corpus and writes recording-level Kaldi data directories
(`wav.scp`, `segments`, `text`, `utt2spk`, `rttm.scp`, `uem`).

```bash
bash data_prep/prepare_ami.sh
bash data_prep/prepare_alimeeting.sh
bash data_prep/prepare_mmcsg.sh
bash data_prep/prepare_dipco.sh
```

Set the corpus root path inside each script before running.
Each script supports two recording conditions controlled by `cond`:

- **SDM1** — single distant microphone (mono, channel 0).
- **MDM** — all distant microphones (multi-channel).

**Optional — Beamforming for MDM**

To create a beamformed single-channel version of MDM data (e.g. `MDM_BF0,2,4,6`):

```bash
bash data_prep/beamformit.sh
```

This calls BeamformIt on selected channel subsets and writes a new Kaldi data directory.

---

## Step 2: Task-specific Data Preparation

### ASR

Cuts recording-level WAV files into per-utterance segments and applies a duration filter
(default 0.1–20.0 s) to produce the `train_filter` and `dev_filter` directories used during training.

```bash
# AMI  (splits: train, dev, test)
bash downstream/asr_ami/prepare_asr_seg.sh

# AliMeeting  (splits: Train, Eval, Test)
bash downstream/asr_alimeeting/prepare_asr_seg.sh

# MMCSG  (splits: train, dev, eval)
bash downstream/asr_mmcsg/prepare_asr_seg.sh

# DiPCo  (splits: dev, eval — no training set)
bash downstream/asr_dipco/prepare_asr_seg.sh
```

Set `alimeeting_data_dir` / `ami_data_dir` / etc. and `output_base_dir` inside each script.
The scripts reuse `downstream/asr_ami/prepare_asr_seg.py` and `downstream/asr_ami/filter_utt.py`.

Expected output structure (AMI example):

```
/path/to/downstream/asr_ami/
  SDM1/
    train/          ← unfiltered segments (wav.scp, text, utt2spk, ...)
    train_filter/   ← duration-filtered, used for training
    dev/
    dev_filter/     ← used for validation
    test/           ← unfiltered, used for evaluation
```

### Diarization

Converts recording-level Kaldi data into fixed-length frame-label sequences for
speaker diarization training.

```bash
# AMI
bash downstream/diar_ami/prepare_diar_seg.sh

# AliMeeting
bash downstream/diar_alimeeting/prepare_diar_seg.sh
```

Set `input_dir` and `output_dir` inside each script.

### SE / SS (Speech Enhancement / Separation)

Prepares clean reference segments from the IHM microphone and simulates
multi-channel mixtures using room impulse responses.

```bash
# Step 1 — extract clean IHM reference segments
bash downstream/sep_ami/prepare_clean_segs.sh \
    /path/to/data/AMI/SDM1 \
    /path/to/downstream/sep_ami/IHM_CLEAN \
    /path/to/ami/annotations

# Step 2 — simulate reverberant / noisy multi-channel mixtures
bash downstream/sep_ami/simu_mch_data.sh
```

For AliMeeting, use the corresponding scripts under `downstream/sep_alimeeting/`.

---

## Step 3: Training

All training scripts call `run_downstream.py` from the s3prl root.
Set `upstream` to any s3prl-supported model name (e.g. `hubert_base`, `wavlm_base_plus`).
Set `cond` to select the recording condition and `asr_data_dir` / `diar_data_dir` / `sep_data_dir`
to point to the prepared data.

To use a custom pre-trained upstream checkpoint, uncomment the `ckpt=` line in the script
and add `-k ${ckpt}` to the `run_downstream.py` call.

### ASR

```bash
bash train_scripts/asr_ami.sh       # AMI
bash train_scripts/asr_alm.sh       # AliMeeting
bash train_scripts/asr_mmcsg.sh     # MMCSG
```

**DiPCo note**: DiPCo has no training split. Its `dev` split is used for fine-tuning
and `eval` for testing. Edit `downstream/asr_dipco/config/DiPCo_final/cfg.yaml`
to set the data paths directly.

Checkpoints are saved under `exp/asr_{corpus}/{upstream}_{lr}_{cond}/`.
The best checkpoint on the dev set (`dev-best.ckpt`) is selected based on WER (or UER
for AliMeeting, which uses character error rate).

### Diarization

```bash
bash train_scripts/diar_ami.sh      # AMI
bash train_scripts/diar_alm.sh      # AliMeeting
bash train_scripts/diar_mmcsg.sh    # MMCSG
```

Each script sweeps over multiple learning rates (e.g. `0.001` and `0.0001`).
Checkpoints are saved under `exp/diar_{corpus}/{upstream}_{lr}_{cond}/`.

### SE / SS

```bash
bash train_scripts/sep_ami.sh       # AMI
bash train_scripts/sep_alm.sh       # AliMeeting
```

Checkpoints are saved under `exp/sep_{corpus}/{upstream}_{lr}_{cond}/`.

---

## Step 4: Evaluation

### ASR

Run inference and score with WER using ESPnet's `sclite` tool.

```bash
bash eval_scripts/asr_ami_infer.sh
bash eval_scripts/asr_alimeeting_infer.sh
```

Internally, inference calls:

```bash
python3 run_downstream.py \
    -m evaluate \
    -e /path/to/exp/dev-best.ckpt \
    -o "config.downstream_expert.loaderrc.test_dir=${test_dir},,..."
```

Then `downstream/asr_ami/score.sh` converts the `.ark` hypothesis/reference files
to `.trn` format and calls `sclite` to compute WER. Results are written to
`result_test.txt` in the experiment directory.

To decode with a KenLM language model, set `decoder_type: kenlm` in the downstream
config and provide the `kenlm_model` and `lexicon` paths.

### Diarization

The evaluation script sweeps over clustering thresholds on `dev`, selects the best
threshold by DER, then runs final evaluation on `test`.

```bash
bash eval_scripts/diar_ami_infer.sh
bash eval_scripts/diar_alm_infer.sh
bash eval_scripts/diar_mmcsg_infer.sh
```

The evaluation uses:

```bash
python3 downstream/diar_ami/evaluate_v1.py \
    /path/to/checkpoint \
    /path/to/data/test \
    /path/to/output/rttm \
    --channel 0 \
    --cluster_thres 0.6 \
    --segmentation_thres 0.5
```

Hypothesis RTTMs are then scored with `md-eval.pl`:

```bash
./downstream/diar_ami/md-eval.pl \
    -r /path/to/data/test/ref_rttm \
    -s /path/to/output/rttm/hyp_rttm \
    -u /path/to/data/test/uem
```

The reported metric is **DER** (Diarization Error Rate), decomposed into
missed speech (MISS), false alarm (FA), and speaker confusion (CF).

### SE / SS

The inference script runs the trained separation model on test mixtures, then
transcribes the separated outputs with an ESPnet ASR model and scores WER
using minimum-permutation matching across speakers.

```bash
bash eval_scripts/sep_ami_infer.sh
bash eval_scripts/sep_alm_infer.sh
```

Set `exp_dir`, `ckpt`, and the ESPnet ASR model paths inside the script.
The script outputs per-group WER results (e.g. `test_utt_group_1spk`, `test_utt_group_2spk`).
