#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 29 14:50:26 2017

@author: johsj47
"""

import scream_c

for i in range(2004,2014):
    parse_directory("/media/johsj47/23E8E28F50B9493D/corpus/GP/splitted_gp"+str(i),
                    "/media/johsj47/23E8E28F50B9493D/corpus/GP/gp"+str(i)+".csv")