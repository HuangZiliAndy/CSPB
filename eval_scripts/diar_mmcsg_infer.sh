#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=15360
#SBATCH --job-name=diar_eval
#SBATCH --time=3-00:00:00
#SBATCH --gpus=1
#SBATCH --exclude=c04,octopod

source path.sh

gpus=1
port=25652
normalize=1

exp_dir="exp/diar_mmcsg/"
ckpt="${exp_dir}/best-states-dev.ckpt"

cond=sdm1
if [[ "$cond" == "mdm_0,2,4,6" ]]; then
    data="MDM"
    channel="0,2,4,6"
elif [[ "$cond" == "mdm_0,4" ]]; then
    data="MDM"
    channel="0,4"
elif [[ "$cond" == "mdm_bf0,2,4,6" ]]; then
    data="MDM_BF0,2,4,6"
    channel="0"
elif [[ "$cond" == "mdm_bf0,4" ]]; then
    data="MDM_BF0,4"
    channel="0"
elif [[ "$cond" == "sdm1" ]]; then
    data="SDM1"
    channel="0"
else
    exit 1;
fi

data_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/${data}
dev_dir="${data_dir}/dev"
test_dir="${data_dir}/eval"

echo $dev_dir
echo $test_dir
echo $channel
echo $ckpt

segmentation_thres=0.5

# Speakers are assigned using the ground-truth RTTM (--gt_spk_assign 1), so the
# DER reflects the segmentation model only and no clustering threshold is tuned.
output_dir=$exp_dir/rttm_gt_spk_assign/test
mkdir -p $output_dir

python3 downstream/diar_ami/evaluate_v1.py \
	$ckpt \
	$test_dir \
	$output_dir \
	--channel $channel \
	--gt_spk_assign 1 \
	--normalize $normalize \
	--segmentation_thres $segmentation_thres \
	--ref_rttm $test_dir/ref_rttm

cat $output_dir/*.rttm > $output_dir/hyp_rttm
./downstream/diar_ami/md-eval.pl -r ${test_dir}/ref_rttm -s $output_dir/hyp_rttm -u ${test_dir}/uem
