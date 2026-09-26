#!/bin/bash
#SBATCH --partition=gpu 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=15360
#SBATCH --job-name=sep_infer
#SBATCH --time=3-00:00:00
#SBATCH --gpus=1
#SBATCH --exclude=c04,octopod,c08,c14

source path.sh

normalize=1

exp_dir="/export/c02/hzili1/workspace/s3prl/s3prl/exp/sep_alm/wavlm_base_plus_0.0001_sdm1"
ckpt="${exp_dir}/best-states-dev.ckpt"

data_dir="/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting/SDM1/"
sdm1_data_dir="/export/c02/hzili1/datasets/s3prl_csp/downstream/sep_alimeeting/SDM1/"
test_sets="Test_utt_group_1spk Test_utt_group_2spk"
channel='0'

# ESPnet checkout (provides utils/ and tools/activate_python.sh)
export ESPNET_DIR=/export/c02/hzili1/workspace/espnet
# Pretrained AliMeeting ASR + LM: unzipped alimeeting_near_conformer_tlm.zip (see README, "SE / SS" evaluation)
asr_dir=/path/to/alimeeting_near_conformer_tlm
asr_config=$asr_dir/exp/asr_train_asr_conformer/config.yaml
asr_model=$asr_dir/exp/asr_train_asr_conformer/valid.acc.ave.pth
lm_config=$asr_dir/exp/lm_train_lm_transformer/config.yaml
lm_model=$asr_dir/exp/lm_train_lm_transformer/valid.loss.ave_10best.pth
decode_config=$(pwd)/downstream/sep_alimeeting/conf/decode_asr_rnn.yaml
nj=32
utils=$ESPNET_DIR/egs2/TEMPLATE/asr1/utils
# Job launcher for ASR decoding: run.pl runs locally; on a Slurm cluster use
# decode_cmd="${utils}/slurm.pl --config /path/to/slurm.conf"
decode_cmd="${utils}/run.pl"
echo $exp_dir
echo $asr_dir

start_time=$(date +%s)

for dir in $test_sets; do
  test_dir="$data_dir/$dir"
  sdm1_dir="$sdm1_data_dir/$dir"
  output_dir=$exp_dir/infer/$dir
  num_srcs=$(cat $test_dir/num_srcs)
  _logdir="${output_dir}/logdir"

  #${AMI_dir}/utils/slurm.pl --config $AMI_dir/conf/slurm.conf --gpu 1 "${_logdir}"/infer_sep.log \
  
  python3 downstream/sep_alimeeting/infer.py $ckpt $test_dir $sdm1_dir $output_dir --channel $channel --normalize $normalize --num_srcs $num_srcs
done

for dir in $test_sets; do
  test_dir="$data_dir/$dir"
  output_dir=$exp_dir/infer/$dir
  mkdir -p $output_dir/split${nj}
  key_file=${output_dir}/wav.scp
  split_scps=""
  for n in $(seq "${nj}"); do
      split_scps+=" ${output_dir}/split${nj}/keys.${n}.scp"
  done
  # shellcheck disable=SC2046,SC2086
  ${utils}/split_scp.pl "${key_file}" ${split_scps}

  # 2. Submit decoding jobs (from asr_dir, so paths inside the ESPnet configs resolve)
  _logdir="${output_dir}/logdir"
  rm -f "${_logdir}/*.log"
  (
    cd $asr_dir
    . $ESPNET_DIR/tools/activate_python.sh
    # shellcheck disable=SC2046,SC2086
    ${decode_cmd} JOB=1:"${nj}" "${_logdir}"/asr_inference.JOB.log \
        python3 -m espnet2.bin.asr_inference \
            --batch_size 1 \
            --ngpu 0 \
            --data_path_and_name_and_type "${output_dir}/wav.scp,speech,sound" \
            --key_file $output_dir/split${nj}/keys.JOB.scp \
            --asr_train_config $asr_config \
            --asr_model_file $asr_model \
            --output_dir "${_logdir}"/output.JOB \
            --config ${decode_config} \
            --lm_train_config ${lm_config} \
            --lm_file ${lm_model} || { cat $(grep -l -i error "${_logdir}"/asr_inference.*.log) ; exit 1; }
  ) || exit 1

  for f in token token_int score text; do
      if [ -f "${_logdir}/output.1/1best_recog/${f}" ]; then
          for i in $(seq "${nj}"); do
              cat "${_logdir}/output.${i}/1best_recog/${f}"
          done | sort -k1 >"${output_dir}/${f}"
      fi
  done

  python3 downstream/sep_alimeeting/permute.py $test_dir/text ${output_dir}/text ${output_dir} --token char
  ./downstream/sep_alimeeting/score.sh $output_dir char 
done

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Duration: $duration seconds"
