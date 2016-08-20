#!/bin/bash

##############################################################################
# Globals
##############################################################################
PRE_EMB_FILENAME="gnvn300.txt"
PRE_EMB_PATH="$HOME/data/GOOGLE/$PRE_EMB_FILENAME"
TRAIN_SCRIPT_PATH="./train.py --tag_scheme=generic "
TRAIN_FILES="--train=../data/dimsum16.train.80.train.tagger --dev=../data/dimsum16.train.20.dev.tagger --test=../data/dimsum16.test.tagger"

##############################################################################
# qsub_train_script
#
# call qsub with fixed parameters and script name
##############################################################################
function qsub_train_script(){
    #cat $1
    qsub -l mem=16G,rmem=16G -m bea -M nmmccoy1@sheffield.ac.uk -j y -o "${1/.sh/.qsub.output.txt}" $1
}

##############################################################################
# run_train_models
#
# generates scripts then calls function to queue script with qsub
##############################################################################
function run_train_models(){
    i=110 # script suffix integer
    # fixed values for training
    rate=0.5
    word_dim_n=300
    word_lstm_dim_n=100
    char_dim_n=10
    char_lstm_dim_n=20
    lower_bool=0
    word_bidirect_bool=1
    char_bidirect_bool=1
    crf_bool=1
    all_emb_bool=0
    # fixed argument strings for train.py
    pre_emb="--pre_emb=$PRE_EMB_PATH"
    word_dim="--word_dim=$word_dim_n"
    word_lstm_dim="--word_lstm_dim=$word_lstm_dim_n"
    dropout_rate="--dropout=$rate"
    char_dim="--char_dim=$char_dim_n"
    char_lstm_dim="--char_lstm_dim=$char_lstm_dim_n"
    bool_args="--all_emb=$all_emb_bool --crf=$crf_bool --lower=$lower_bool --word_bidirect=$word_bidirect_bool --char_bidirect=$char_bidirect_bool "
    outputfn="80_20_split_all_emb_""$all_emb_bool""_crf_""$crf_bool""_char_bidirect_""$char_bidirect_bool""_word_bidirect_""$word_bidirect_bool""_lower_""$lower_bool""_chardim_""$char_dim_n""_charlstmdim_""$char_lstm_dim_n""_dropout_""$rate""_word_dim_""$word_dim_n"".word_lstm_dim_""$word_lstm_dim_n"".$i.stdout.stderr.output"
    scriptprefix="trainmodel_test_preemb_"
    scriptname="$scriptprefix""$i.sh"
    echo '#!/bin/bash' > $scriptname
    echo source activate py27  >> $scriptname
    echo source activate py27  >> $scriptname
    echo python3 -u $TRAIN_SCRIPT_PATH $TRAIN_FILES $bool_args $pre_emb $dropout_rate $char_dim $char_lstm_dim $word_dim $word_lstm_dim \&\> $outputfn >> $scriptname
    chmod +x $scriptname
    qsub_train_script $scriptname
}

################################################################################
# Main function call
################################################################################
function main(){
    run_train_models
}
# call main
main
