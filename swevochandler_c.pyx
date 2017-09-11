#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 22 21:50:22 2017

@author: johsj47
"""

from collections import defaultdict

swevoc = defaultdict(list)

with open("SweVoc_final.txt") as f:
    for line in f:
        splitted = line.split("\t")
        lemma = splitted[2]
        categories = splitted[3].rstrip().split(", ")
        swevoc[lemma] = categories
