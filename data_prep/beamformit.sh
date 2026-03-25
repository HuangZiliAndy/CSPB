# This script performs beamforming using the BeamformIt tookit

export BEAMFORMIT=/export/c02/hzili1/workspace/espnet/tools/BeamformIt
export PATH=${PATH}:${BEAMFORMIT}
export PATH="/export/c02/hzili1/tmp/home/hzili1/anaconda3/envs/csp/bin:$PATH"

mdm_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/MDM
mdm_bf_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF0,2
nj=16

for dset in eval dev train; do 
  python3 data_prep/beamformit_kaldi.py ${mdm_dir}/${dset}/wav.scp ${mdm_bf_dir}/${dset} --config_file data_prep/beamformit.cfg --num_jobs ${nj} --channels 0,2
done

mdm_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/MDM
mdm_bf_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF0,2,3,4
nj=16

for dset in eval dev train; do 
  python3 data_prep/beamformit_kaldi.py ${mdm_dir}/${dset}/wav.scp ${mdm_bf_dir}/${dset} --config_file data_prep/beamformit.cfg --num_jobs ${nj} --channels 0,2,3,4
done

mdm_dir=/export/c02/hzili1/datasets/s3prl_csp/data/MMCSG/MDM
mdm_bf_dir=/export/fs05/hzili1/datasets/s3prl_csp/data/MMCSG/MDM_BF
nj=16

for dset in eval dev train; do 
  python3 data_prep/beamformit_kaldi.py ${mdm_dir}/${dset}/wav.scp ${mdm_bf_dir}/${dset} --config_file data_prep/beamformit.cfg --num_jobs ${nj} --channels 0,1,2,3,4,5,6
done
