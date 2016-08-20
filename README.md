## DiMSUM Tagger
The DiMSUM tagger is modified from the NER Tagger which is an implementation of a Named Entity Recogniser that obtains state-of-the-art performance in NER on the 4 CoNLL datasets (English, Spanish, German and Dutch) without resorting to any language-specific knowledge or resources such as gazetteers. Details about the original model can be found at: http://arxiv.org/abs/1603.01360

The DiMSUM task can be viewed on https://dimsum16.github.io/

## Requirements

This version of the tagger was updated to use Anaconda Python 3.4
To use the tagger, you need Python 3, with Numpy and Theano installed.

Since the system uses an external evaluation script in Python 2, an environment with support for Python 2 is needed. All training and tests used Anaconda Python 2.7 and Anaconda Python 3 with the additional packages specified above. 

The shell scripts provided use an additional python 2.7 environment called `py27`. 

Install Anaconda Python 3.4 as your default installation and run `conda create -n py27 python=2.7` to create the secondary environment needed. 

The additional shell scripts provided `activate` the `py27` environment for training and testing.  

## Usage

### Tag sentences

The fastest way to use the tagger is to use one of the pre-trained models:

```
./tagger.py --model models/modelname/ --input input.txt --output output.txt
```

The input file should contain one sentence by line, and they have to be tokenized. Otherwise, the tagger will perform poorly.

The tagger for the DiMSUM task outputs joint MWE/Supersense tags in a one sentence per line format. the `tagger2dimsum.py` conversion script is provided to change the format of the output to the DiMSUM/CoNLL style files to be used for evaluation. 

An optimal model is provided in the `models` directory for the DiMSUM test sentence file.

### Train a model

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

### Usage with `iceberg`

If you happen to be at the University of Sheffield and would like to use their `iceberg` cluster to run the training, there is additional scripts provided to run the training and tests. 

To train the model for the DiMSUM data with the optimal parameters just run `train_models.sh` and a script will be created and submitted using the `qsub` command. On average the training takes less then 5 Hours. 

To test the model, simply run the `test_models.sh` shell script and it will create a CSV file called `model_tests.csv` with the results.

You can change the parameters in the `train_models.sh` script to generate alternative models and then just run the `test_models.sh` script to get results for all models that exist in the `models` directory.

