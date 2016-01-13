#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print "Usage:", sys.argv[0], "filter_word_file"
    word_dict = {}
    with open(sys.argv[1]) as ins:
        for line in ins:
            word_dict[line.strip()] = 0
    word_list = word_dict.keys()
    for line in sys.stdin:
        for word in word_list:
            if word in line:
                print line.strip()
                break


