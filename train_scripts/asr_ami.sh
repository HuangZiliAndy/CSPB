source path.sh

cache_dir=/export/c02/hzili1/tools/s3prl/s3prl/downloads

upstream=hubert_base

lr=0.0001
gpus=1
port=25652
#distributed="-m torch.distributed.launch --nproc_per_node ${gpus} --master_port ${port}"
distributed=""

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
elif [[ "$cond" == "mdm_bfall" ]]; then
    data="MDM_BF"
    channel="0"
elif [[ "$cond" == "sdm1" ]]; then
    data="SDM1"
    channel="0"
else
    exit 1;
fi

exp_dir="`pwd`/exp/asr_ami/${upstream}_${cfgname}_${iter}_${lr}_${cond}"
train_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_ami/${data}/train_filter
dev_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/asr_ami/${data}/dev_filter

echo $train_dir
echo $dev_dir
echo $channel
echo $exp_dir

python3 $distributed run_downstream.py \
    --cache_dir ${cache_dir} \
    -p $exp_dir \
    -m train \
    -u $upstream \
    -d asr_ami \
    -c downstream/asr_ami/config/AMI/cfg.yaml \
    -o "config.downstream_expert.datarc.channel='${channel}',,config.optimizer.lr=${lr},,config.downstream_expert.loaderrc.train_dir=${train_dir},,config.downstream_expert.loaderrc.dev_dir=${dev_dir}"
