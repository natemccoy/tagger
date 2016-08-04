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
    qsub -l mem=16G,rmem=16G -m bea -M nmmccoy1@sheffield.ac.uk -j y -o "${1/.sh/.qsub.output.txt}" $1
}

##############################################################################
# run_train_models
#
# generates scripts then calls function to queue script with qsub
##############################################################################
function run_train_models(){
    dropout=(0 0.25 0.5)
    char=(5 25)
    i=0
    for rate in "${dropout[@]}"
    do 
	for cdim in "${char[@]}"
	do
	    for word_dim_n in $(seq 100 100 300)
	    do 
		pre_emb=
		if [[ $word_dim_n -eq 300 ]]
		then
		    pre_emb="--pre_emb=$PRE_EMB_PATH"
		fi
		for word_lstm_dim_n in $(seq 100 100 300)
		do
		    i=$(($i+1))
		    outputfn="chardim_""$cdim""_dropout_""$rate""_word_dim_""$word_dim_n"".word_lstm_dim_""$word_lstm_dim_n"".$i.stdout.stderr.output"
		    word_dim="--word_dim=$word_dim_n"
		    word_lstm_dim="--word_lstm_dim=$word_lstm_dim_n"
		    dropout_rate="--dropout=$rate"
		    char_dim="--char_dim=$cdim --char_lstm_dim=$cdim"
		    scriptprefix="trainmodel_test_"
		    scriptname="$scriptprefix""$i.sh"
		    echo '#!/bin/bash' > $scriptname
		    echo source activate py27  >> $scriptname
		    echo python3 -u $TRAIN_SCRIPT_PATH $TRAIN_FILES $dropout_rate $char_dim $word_dim $word_lstm_dim \&\> $outputfn >> $scriptname
		    qsub_train_script $scriptname
		    if [ ! -z $pre_emb ]
		    then
			scriptname="$scriptprefix""preemb_""$i.sh"
		    	outputfn="preemb_${PRE_EMB_FILENAME/\.txt/}_""$outputfn"
			echo '#!/bin/bash' > $scriptname
			echo source activate py27 >> $scriptname
		    	echo python3 -u $TRAIN_SCRIPT_PATH $dropout_rate $char_dim $word_dim $word_lstm_dim $pre_emb \&\> $outputfn >> $scriptname
			qsub_train_script $scriptname
		    fi
		done
	    done
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


