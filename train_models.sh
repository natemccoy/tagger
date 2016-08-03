#!/bin/bash

PRE_EMB_FILENAME="GoogleNews-vectors-negative300.txt"
PRE_EMB_PATH="~/data/GOOGLE/$PRE_EMB_FILENAME"
TRAIN_SCRIPT_PATH="./train.py"
TRAIN_FILES="--train=../data/dimsum16.train.60.train.tagger --dev=../data/dimsum16.train.20.dev.tagger --test=../data/dimsum16.train.20.test.tagger"

function train_models(){
    dropout=(0 0.5)
    char=(0 25)
    for rate in "${dropout[@]}"
    do 
	for cdim in "${char[@]}"
	do
	    # does nothing for not, just 300 word dim
	    for word_dim_n in $(seq 300 100 300)
	    do 
		pre_emb=
		if [[ $word_dim_n -eq 300 ]]
		then
		    pre_emb="--pre_emb=$PRE_EMB_PATH"
		fi
		# does nothing for now, just 300 word lstm dim
		for word_lstm_dim_n in $(seq 300 100 300)
		do
		    outputfn="chardim_""$cdim""_dropout_""$rate""_word_dim_""$word_dim_n"".word_lstm_dim_""$word_lstm_dim_n"".stdout.stderr.output"
		    word_dim="--word_dim=$word_dim_n"
		    word_lstm_dim="--word_lstm_dim=$word_lstm_dim_n"
		    dropout_rate="--dropout=$rate"
		    char_dim="--char_dim=$cdim --char_lstm_dim=$cdim"
		    #echo python -u $TRAIN_SCRIPT_PATH $TRAIN_FILES $dropout_rate $char_dim $word_dim $word_lstm_dim \> $outputfn
		    
		    if [ ! -z $pre_emb ]
		    then
		    	outputfn="preemb_${PRE_EMB_FILENAME/\.txt/}_""$outputfn"
		    	echo python -u $TRAIN_SCRIPT_PATH $dropout_rate $char_dim $word_dim $word_lstm_dim $pre_emb \&\> $outputfn
			python -u $TRAIN_SCRIPT_PATH $TRAIN_FILES $dropout_rate $char_dim $word_dim $word_lstm_dim $pre_emb &> $outputfn
		    fi
		done
	    done
	done
    done
}

train_models

