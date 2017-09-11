#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 25 13:51:50 2017

@author: johsj47
"""

import cProfile
import scream_c

source = "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Smittskydd/741"
out = "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Smittskydd/python_parsed741.csv"

cProfile.run('scream_c.parse_directory(source, out)')
