#!/bin/bash

PRE_EMB_FILENAME="GoogleNews-vectors-negative300.txt"
PRE_EMB_PATH="~/data/GOOGLE/$PRE_EMB_FILENAME"
TRAIN_SCRIPT_PATH="./train.py"

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
		    echo python -u $TRAIN_SCRIPT_PATH $dropout_rate $char_dim $word_dim $word_lstm_dim \> $outputfn
		    
		    #if [ ! -z $pre_emb ]
		    #then
		    #	outputfn="preemb_${PRE_EMB_FILENAME/\.txt/}_""$outputfn"
		    #	echo python -u $TRAIN_SCRIPT_PATH $dropout_rate $word_dim $word_lstm_dim $pre_emb \> $outputfn
		    #fi
		done
	    done
	done
    done
}

train_models

#python -u ./train.py --dropout=0 --char_dim=0 --char_lstm_dim=0 --word_dim=300 --word_lstm_dim=300 > chardim_0_dropout_0_word_dim_300.word_lstm_dim_300.stdout.stderr.output
#python -u ./train.py --dropout=0 --word_dim=300 --word_lstm_dim=300 --pre_emb=~/data/GOOGLE/GoogleNews-vectors-negative300.txt > preemb_GoogleNews-vectors-negative300_chardim_0_dropout_0_word_dim_300.word_lstm_dim_300.stdout.stderr.output
#python -u ./train.py --dropout=0 --char_dim=25 --char_lstm_dim=25 --word_dim=300 --word_lstm_dim=300 > chardim_25_dropout_0_word_dim_300.word_lstm_dim_300.stdout.stderr.output
#python -u ./train.py --dropout=0 --word_dim=300 --word_lstm_dim=300 --pre_emb=~/data/GOOGLE/GoogleNews-vectors-negative300.txt > preemb_GoogleNews-vectors-negative300_chardim_25_dropout_0_word_dim_300.word_lstm_dim_300.stdout.stderr.output
#python -u ./train.py --dropout=0.5 --char_dim=0 --char_lstm_dim=0 --word_dim=300 --word_lstm_dim=300 > chardim_0_dropout_0.5_word_dim_300.word_lstm_dim_300.stdout.stderr.output
#python -u ./train.py --dropout=0.5 --word_dim=300 --word_lstm_dim=300 --pre_emb=~/data/GOOGLE/GoogleNews-vectors-negative300.txt > preemb_GoogleNews-vectors-negative300_chardim_0_dropout_0.5_word_dim_300.word_lstm_dim_300.stdout.stderr.output
#python -u ./train.py --dropout=0.5 --char_dim=25 --char_lstm_dim=25 --word_dim=300 --word_lstm_dim=300 > chardim_25_dropout_0.5_word_dim_300.word_lstm_dim_300.stdout.stderr.output
#python -u ./train.py --dropout=0.5 --word_dim=300 --word_lstm_dim=300 --pre_emb=~/data/GOOGLE/GoogleNews-vectors-negative300.txt > preemb_GoogleNews-vectors-negative300_chardim_25_dropout_0.5_word_dim_300.word_lstm_dim_300.stdout.stderr.output
