## DiMSUM Tagger
The DiMSUM tagger is modified from the NER Tagger which is an implementation of a Named Entity Recognizer that obtains state-of-the-art performance in NER on the 4 CoNLL datasets (English, Spanish, German and Dutch) without resorting to any language-specific knowledge or resources such as gazetteers. Details about the model can be found at: http://arxiv.org/abs/1603.01360

The DiMSUM task can be viewed on https://dimsum16.github.io/

## Initial setup

This version of the tagger was updated to use Python 3.
To use the tagger, you need Python 3, with Numpy and Theano installed.

## Tag sentences

The fastest way to use the tagger is to use one of the pretrained models:

```
./tagger.py --model models/modelname/ --input input.txt --output output.txt
```

The input file should contain one sentence by line, and they have to be tokenized. Otherwise, the tagger will perform poorly.

The tagger for the DiMSUM task outputs joint MWE/Supersense tags.

## Train a model

To train your own model, you need to use the train.py script and provide the location of the training, development and testing set:

```
./train.py --train train.txt --dev dev.txt --test test.txt
```

The training script will automatically give a name to the model and store it in ./models/
There are many parameters you can tune (CRF, dropout rate, embedding dimension, LSTM hidden layer size, etc). To see all parameters, simply run:

```
./train.py --help
```

Input files for the training script have to follow the same format than the CoNLL2003 sharing task: each word has to be on a separate line, and there must be an empty line after each sentence. A line must contain at least 2 columns, the first one being the word itself, the last one being the named entity. It does not matter if there are extra columns that contain tags or chunks in between. 

In the case of the DiMSUM task, a modified training/testing files are used with additional 1st and last columns of words and joint MWE/Supersense tags.
