#!/bin/bash

##############################################################################
# Globals
##############################################################################
PRE_EMB_FILENAME="GoogleNews-vectors-negative300.txt"
PRE_EMB_PATH="$HOME/data/GOOGLE/$PRE_EMB_FILENAME"
TRAIN_SCRIPT_PATH="./train.py --tag_scheme=generic "
TRAIN_FILES="--train=../data/dimsum16.train.60.train.tagger --dev=../data/dimsum16.train.20.dev.tagger --test=../data/dimsum16.train.20.test.tagger"

##############################################################################
# qsub_train_script
#
# call qsub with fixed parameters and script name
##############################################################################
function qsub_train_script(){
    qsub -l mem=16G,rmem=16G,h_rt=48:00:00 -m bea -M nmmccoy1@sheffield.ac.uk -j y -o "${1/.sh/.qsub.output.txt}" $1
}

##############################################################################
# run_train_models
#
# generates scripts then calls function to queue script with qsub
##############################################################################
function run_train_models(){
    char=(10 20 30 40)
    i=66
    rate=0.5
    pre_emb="--pre_emb=$PRE_EMB_PATH"
    word_dim_n=300
    word_lstm_dim_n=100
    for cdim in "${char[@]}"
    do
	for cldim in "${char[@]}"
	do
	    i=$(($i+1))
	    outputfn="chardim_""$cdim""_charlstmdim_""$cldim""_dropout_""$rate""_word_dim_""$word_dim_n"".word_lstm_dim_""$word_lstm_dim_n"".$i.stdout.stderr.output"
	    word_dim="--word_dim=$word_dim_n"
	    word_lstm_dim="--word_lstm_dim=$word_lstm_dim_n"
	    dropout_rate="--dropout=$rate"
	    char_dim="--char_dim=$cdim --char_lstm_dim=$cldim"
	    scriptprefix="trainmodel_test_preemb_"
	    scriptname="$scriptprefix""$i.sh"
	    echo '#!/bin/bash' > $scriptname
	    echo source activate py27  >> $scriptname
	    echo source activate py27  >> $scriptname
	    echo python3 -u $TRAIN_SCRIPT_PATH $TRAIN_FILES $pre_emb $dropout_rate $char_dim $word_dim $word_lstm_dim \&\> $outputfn >> $scriptname
	    chmod +x $scriptname
	    qsub_train_script $scriptname
	done
    done
}

################################################################################
# Main function call
################################################################################
function main(){
    run_train_models
}
# call main
main


