#!/bin/bash

###############################################################################
# Globals
###############################################################################
input='../data/dimsum16.train.20.test'
output='dimsum16.train.20.test.tagged'
modeleval="model.eval.tmp"
header='tag_scheme,lower,zeros,char_dim,char_lstm_dim,char_bidirect,word_dim,word_lstm_dim,word_bidirect,pre_emb,all_emb,cap_dim,crf,dropout,lr_method,MWE F1, Supersense F1, Combined F1,'
modeltestcsv="model_tests.csv"
CONV_SCRIPT='../data/conversion/tagger2dimsum.py'
TAGR_SCRIPT='./tagger.py'
EVAL_SCRIPT='evaluation/dimsumeval.py'

###############################################################################
# run_test_models
#
# goes through each model in "models" directory and runs the tagger
# and creates evaluation results CSV file in $modeltestcsv
###############################################################################
function run_test_models(){
    echo $header > $modeltestcsv
    for model in models/*
    do
	$TAGR_SCRIPT --model=$model --input="$input.sentences" --output="$output" || rm $modeleval
	$CONV_SCRIPT "$input.blind" "$output" > "$output.pred"
	$EVAL_SCRIPT -C $input "$output.pred" > $modeleval
	echo $model | sed 's/,/\n/g' | sed 's/^.*=//g' | tr '\n' ',' >> $modeltestcsv
	echo "$(tail -n 3 $modeleval | awk '{print $NF}' | sed 's/^.*=\|%//g' | tr '\n' ',')" >> $modeltestcsv
	rm $modeleval
    done
}

###############################################################################
# Main function call
###############################################################################
function main(){
    run_test_models 
}

# call main
main
