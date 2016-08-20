#!/usr/bin/end python

###############################################################################
# class TaggerDataIterator
#
# opens and iterates over sentence data in a file generated by tagger.py
# splits the elements in each sentence
###############################################################################
class TaggerDataIterator(object):
    def __init__(self,filename):
        # all the lines from the file
        self.lines = open(filename).readlines()
        # clean the newlines, make each line a list
        self.lines = [line.strip().split() for line in self.lines]
        # start index of next data item
        self.i = 0
    def __iter__(self):
        return self
    def __next__(self):
        item = self.__nextItem()
        if item:
            return item
        else:
            raise StopIteration()
    # for ease of use, just calls __next__
    def next(self):
        return self.__next__()
    # get the next item. list of lists. each list is a row in sentence,
    # with the corresponding columns for the shared task. (in README.md)
    def __nextItem(self):
        if self.i < len(self.lines):
            item = [pred.rsplit('__', maxsplit=2) for pred in self.lines[self.i]]
            self.i+=1
            return item
        else:
            return None

