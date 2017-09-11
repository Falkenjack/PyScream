#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 23 16:58:21 2017

@author: johsj47
"""

from math import log, inf

def computeLix(w, s, lw):
    return (w / s) + ((lw * 100) / w)

def computeOvix(w, uw):
    if uw<w:
        return log(w) / log(2 - (log(uw) / log(w)))
    else:
        return inf

def computeNominalRatio(noun, prep, part, pro, adv, verb):
    return (noun + prep + part) / (pro + adv + verb)