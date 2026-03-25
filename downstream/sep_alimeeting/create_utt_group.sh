#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=15360
#SBATCH --job-name=prepare_uttgroup
#SBATCH --time=3-00:00:00
#SBATCH --gpus=1
#SBATCH --exclude=c04

source path.sh

#data=MDM_BF0,4
#data_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/${data}
#output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting
#
#python3 downstream/sep_alimeeting/create_utt_group.py $data_dir/Eval $output_dir/$data/Eval_utt_group
#python3 downstream/sep_alimeeting/create_utt_group.py $data_dir/Test $output_dir/$data/Test_utt_group
#
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Eval_utt_group $output_dir/$data/Eval_utt_group_1spk --max_num_spks 1 --min_num_spks 1
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Eval_utt_group $output_dir/$data/Eval_utt_group_2spk --max_num_spks 2 --min_num_spks 2
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Test_utt_group $output_dir/$data/Test_utt_group_1spk --max_num_spks 1 --min_num_spks 1
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Test_utt_group $output_dir/$data/Test_utt_group_2spk --max_num_spks 2 --min_num_spks 2

data=MDM_BF0,2,4,6
data_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/${data}
output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting

python3 downstream/sep_alimeeting/create_utt_group.py $data_dir/Eval $output_dir/$data/Eval_utt_group
python3 downstream/sep_alimeeting/create_utt_group.py $data_dir/Test $output_dir/$data/Test_utt_group

python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Eval_utt_group $output_dir/$data/Eval_utt_group_1spk --max_num_spks 1 --min_num_spks 1
python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Eval_utt_group $output_dir/$data/Eval_utt_group_2spk --max_num_spks 2 --min_num_spks 2
python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Test_utt_group $output_dir/$data/Test_utt_group_1spk --max_num_spks 1 --min_num_spks 1
python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Test_utt_group $output_dir/$data/Test_utt_group_2spk --max_num_spks 2 --min_num_spks 2

#data=MDM_BF
#data_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/${data}
#output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting
#
#python3 downstream/sep_alimeeting/create_utt_group.py $data_dir/Eval $output_dir/$data/Eval_utt_group
#python3 downstream/sep_alimeeting/create_utt_group.py $data_dir/Test $output_dir/$data/Test_utt_group
#
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Eval_utt_group $output_dir/$data/Eval_utt_group_1spk --max_num_spks 1 --min_num_spks 1
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Eval_utt_group $output_dir/$data/Eval_utt_group_2spk --max_num_spks 2 --min_num_spks 2
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Test_utt_group $output_dir/$data/Test_utt_group_1spk --max_num_spks 1 --min_num_spks 1
#python3 downstream/sep_alimeeting/filter_utt_group.py $output_dir/$data/Test_utt_group $output_dir/$data/Test_utt_group_2spk --max_num_spks 2 --min_num_spks 2
