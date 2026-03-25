#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=15360
#SBATCH --job-name=prepare_diar_seg
#SBATCH --time=1-00:00:00
#SBATCH --exclude=c04,octopod

export PATH="/export/c02/hzili1/tmp/home/hzili1/anaconda3/envs/csp/bin:$PATH"

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/SDM1/
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/diar_alimeeting/SDM1
#
#for split in Eval Test Train; do
#  python3 downstream/diar_alimeeting/prepare_diar_seg.py \
#	--normalize 1 \
#	${input_dir}/${split} \
#	${output_dir}/${split}
#  python3 downstream/diar_alimeeting/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/MDM_BF0,4
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/diar_alimeeting/MDM_BF0,4
#
#for split in Eval Test Train; do
#  python3 downstream/diar_alimeeting/prepare_diar_seg.py \
#	--normalize 1 \
#	${input_dir}/${split} \
#	${output_dir}/${split}
#  python3 downstream/diar_alimeeting/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/MDM_BF0,2,4,6
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/diar_alimeeting/MDM_BF0,2,4,6

#for split in Eval Test Train; do
#  python3 downstream/diar_alimeeting/prepare_diar_seg.py \
#	--normalize 1 \
#	${input_dir}/${split} \
#	${output_dir}/${split}
#  python3 downstream/diar_alimeeting/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/sep_cfg0_SoudenMVDR_2CH
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/diar_alimeeting/sep_cfg0_SoudenMVDR_2CH

for split in Eval Test Train; do
  python3 downstream/diar_alimeeting/prepare_diar_seg.py \
	--normalize 1 \
	${input_dir}/${split} \
	${output_dir}/${split}
  python3 downstream/diar_alimeeting/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/sep_cfg0_SoudenMVDR_4CH
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/diar_alimeeting/sep_cfg0_SoudenMVDR_4CH

for split in Eval Test Train; do
  python3 downstream/diar_alimeeting/prepare_diar_seg.py \
	--normalize 1 \
	${input_dir}/${split} \
	${output_dir}/${split}
  python3 downstream/diar_alimeeting/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/Alimeeting/sep_cfg0_SoudenMVDR_8CH
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/diar_alimeeting/sep_cfg0_SoudenMVDR_8CH

for split in Eval Test Train; do
  python3 downstream/diar_alimeeting/prepare_diar_seg.py \
	--normalize 1 \
	${input_dir}/${split} \
	${output_dir}/${split}
  python3 downstream/diar_alimeeting/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
done
