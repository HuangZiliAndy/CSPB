#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=15360
#SBATCH --job-name=prepare_diar_seg
#SBATCH --time=1-00:00:00
#SBATCH --exclude=c04

export PATH="/export/c02/hzili1/tmp/home/hzili1/anaconda3/envs/csp/bin:$PATH"

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/SDM1/
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/diar_mmcsg/SDM1

#for split in dev eval train; do
#  python3 downstream/diar_mmcsg/prepare_diar_seg.py \
#	--normalize 1 \
#	--chunk_size 10.0 \
#	--stride_size 5.0 \
#	${input_dir}/${split} \
#	${output_dir}/${split}
#  python3 downstream/diar_mmcsg/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

#input_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/MDM/
#output_dir=/export/c02/hzili1/datasets/s3prl_csp/downstream/diar_mmcsg/MDM
#
#for split in dev eval train; do
#  python3 downstream/diar_mmcsg/prepare_diar_seg.py \
#	--normalize 1 \
#	--chunk_size 10.0 \
#	--stride_size 5.0 \
#	${input_dir}/${split} \
#	${output_dir}/${split}
#  python3 downstream/diar_mmcsg/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
#done

input_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF0,2/
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/diar_mmcsg/MDM_BF0,2

for split in dev eval train; do
  python3 downstream/diar_mmcsg/prepare_diar_seg.py \
	--normalize 1 \
	--chunk_size 10.0 \
	--stride_size 5.0 \
	${input_dir}/${split} \
	${output_dir}/${split}
  python3 downstream/diar_mmcsg/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF0,2,3,4/
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/diar_mmcsg/MDM_BF0,2,3,4

for split in dev eval train; do
  python3 downstream/diar_mmcsg/prepare_diar_seg.py \
	--normalize 1 \
	--chunk_size 10.0 \
	--stride_size 5.0 \
	${input_dir}/${split} \
	${output_dir}/${split}
  python3 downstream/diar_mmcsg/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
done

input_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF/
output_dir=/export/fs05/hzili1/datasets/s3prl_csp/downstream/diar_mmcsg/MDM_BF

for split in dev eval train; do
  python3 downstream/diar_mmcsg/prepare_diar_seg.py \
	--normalize 1 \
	--chunk_size 10.0 \
	--stride_size 5.0 \
	${input_dir}/${split} \
	${output_dir}/${split}
  python3 downstream/diar_mmcsg/filter_seg.py ${output_dir}/${split} ${output_dir}/${split}_filter
done
