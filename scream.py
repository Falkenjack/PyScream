#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 23 11:07:47 2017

@author: johsj47
"""

import os
import screamparser as p
from swevochandler import swevoc

#d = parser.parse_file("2009-01-09_Nyheter_Torbjorn_Skarhed_Havsorn.xml")

source = "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Smittskydd/741"
out = "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Smittskydd/python_parsed741.csv"

def parse_directory(source, out):
    with open(out, 'w') as o:
        o.write("avgSentenceLength,avgWordLength,avgNoSyllables,ratioSweVocTotal,ratioSweVocC,ratioSweVocD,ratioSweVocH,pos_RG,pos_CITE,pos_JJ,pos_DT,pos_HS,pos_HP,pos_RO,pos_MID,pos_PAD,pos_NN,pos_VB,pos_IE,pos_HD,pos_MAD,pos_IN,pos_UO,pos_KN,pos_HA,pos_SN,pos_PL,pos_PM,pos_PN,pos_AB,pos_PP,pos_PS,pos_PLQS,pos_PC,lexicalDensity,dep_VS,dep_YY,dep_VO,dep_DT,dep_VG,dep_VA,dep_I?,dep_IC,dep_RA,dep_IG,dep_IF,dep_MA,dep_AT,dep_IK,dep_+F,dep_XX,dep_IO,dep_IP,dep_IQ,dep_IR,dep_IS,dep_+A,dep_IT,dep_IU,dep_IV,dep_MS,dep_PT,dep_UA,dep_EO,dep_AA,dep_ET,dep_AG,dep_ES,dep_JC,dep_EF,dep_NA,dep_++,dep_JG,dep_AN,dep_XT,dep_CA,dep_FV,dep_JT,dep_JR,dep_FS,dep_KA,dep_XA,dep_SS,dep_FO,dep_XF,dep_FP,dep_ROOT,dep_OA,dep_TA,dep_HD,dep_DB,dep_SP,dep_OP,dep_OO,dep_PL,dep_CJ,dep_PA,meanDepDistanceDependent,meanDepDistanceSentence,ratioRightDeps,avgSentenceDepth,verbArity0,verbArity1,verbArity2,verbArity3,verbArity4,verbArity5,verbArity6,verbArity7,ratioVerbalRoots,avgVerbalArity,avgNominalPremodifiers,avgNominalPostmodifiers,avgPrepComp,avgWordsPerClause,lixValue,ovixValue,nrValue,name,label\n")
        os.chdir(source)
        for filename in sorted(os.listdir(source)):
            #print(filename)
            fv = p.parse_file(filename, swevoc)
            o.write(fv.toCsvOld())
            
    print(source, "completed")
#with open(source + '/' + 'Allt fler drabbas av sexuellt verfrda infektioner.xml', 'rb') as infile:
#    for i, line in enumerate(infile):
#        if i>1658 and i<1719:
#            print(line)