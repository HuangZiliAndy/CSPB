#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=15360
#SBATCH --job-name=asr_mmcsg_infer
#SBATCH --time=3-00:00:00
#SBATCH --gpus=1

source path.sh

# Must match the upstream / lr / cond used in train_scripts/asr_mmcsg.sh
upstream=hubert_base
lr=0.0001

cond=sdm1
if [[ "$cond" == "sdm1" ]]; then
    data="SDM1"
    channel="0"
elif [[ "$cond" == "mdm_0,2" ]]; then
    data="MDM"
    channel="0,2"
elif [[ "$cond" == "mdm_0,2,3,4" ]]; then
    data="MDM"
    channel="0,2,3,4"
elif [[ "$cond" == "mdm_all" ]]; then
    data="MDM"
    channel="0,1,2,3,4,5,6"
elif [[ "$cond" == "mdm_bf0,2" ]]; then
    data="MDM_BF0,2"
    channel="0"
elif [[ "$cond" == "mdm_bf0,2,3,4" ]]; then
    data="MDM_BF0,2,3,4"
    channel="0"
elif [[ "$cond" == "mdm_bfall" ]]; then
    data="MDM_BF"
    channel="0"
else
    exit 1;
fi

exp_dir="`pwd`/exp/asr_mmcsg/${upstream}_${lr}_${cond}"
ckpt="${exp_dir}/dev-best.ckpt"

# Root directory containing the segmented ASR data produced by
# downstream/asr_mmcsg/prepare_asr_seg.sh. The test set is eval_filter_30s
# (eval utterances of at most 30 s).
asr_data_dir=/path/to/downstream/asr_mmcsg
test_dir="${asr_data_dir}/${data}/eval_filter_30s"

# ESPnet checkout, used by score.sh for tokenize_text.py and sclite
export ESPNET_DIR=/path/to/espnet

echo $test_dir
echo $channel
echo $ckpt

python3 run_downstream.py \
    -m evaluate \
    -e $ckpt \
    -o "config.downstream_expert.datarc.max_samples=1000000,,config.downstream_expert.loaderrc.test_dir=${test_dir},,config.downstream_expert.datarc.channel='${channel}'"

./downstream/asr_mmcsg/score.sh $exp_dir false $test_dir
