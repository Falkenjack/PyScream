#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 23 16:58:21 2017

@author: johsj47
"""

from math import log, inf

cpdef double computeLix(double w, double s, double lw):
    return (w / s) + ((lw * 100) / w)

cpdef double computeOvix(double w, double uw):
    if uw<w:
        return log(w) / log(2 - (log(uw) / log(w)))
    else:
        return inf

cpdef double computeNominalRatio(double noun,
                          double prep,
                          double part,
                          double pro,
                          double adv,
                          double verb):
    return divisionOrZero(noun + prep + part, pro + adv + verb)

cpdef double divisionOrZero(double num, double denom):
    if denom != 0:
        return num/denom
    else:
        return 0