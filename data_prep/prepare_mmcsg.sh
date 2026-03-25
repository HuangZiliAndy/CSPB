#!/bin/bash

# download MMCSG dataset from https://ai.meta.com/datasets/mmcsg-dataset/
MMCSG_dir=/export/c02/hzili1/datasets/MMCSG/MMCSG
cond=SDM1
output_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG

python3 data_prep/prepare_mmcsg.py \
	${MMCSG_dir} \
	${output_dir} \
	--cond ${cond} \
	--merge_dis 0.5
