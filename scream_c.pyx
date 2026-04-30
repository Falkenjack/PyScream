#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 23 11:07:47 2017

@author: johsj47
"""

import os
import screamparser_c as p
from swevochandler_c import swevoc

#d = parser.parse_file("2009-01-09_Nyheter_Torbjorn_Skarhed_Havsorn.xml")


cpdef parse_directory(source, out):
    print("Starting", source)
    with open(out, 'w') as o:
        o.write("avgSentenceLength;avgWordLength;avgNoSyllables;ratioSweVocTotal;ratioSweVocC;ratioSweVocD;ratioSweVocH;pos_RG;pos_CITE;pos_JJ;pos_DT;pos_HS;pos_HP;pos_RO;pos_MID;pos_PAD;pos_NN;pos_VB;pos_IE;pos_HD;pos_MAD;pos_IN;pos_UO;pos_KN;pos_HA;pos_SN;pos_PL;pos_PM;pos_PN;pos_AB;pos_PP;pos_PS;pos_PLQS;pos_PC;lexicalDensity;dep_VS;dep_YY;dep_VO;dep_DT;dep_VG;dep_VA;dep_I?;dep_IC;dep_RA;dep_IG;dep_IF;dep_MA;dep_AT;dep_IK;dep_+F;dep_XX;dep_IO;dep_IP;dep_IQ;dep_IR;dep_IS;dep_+A;dep_IT;dep_IU;dep_IV;dep_MS;dep_PT;dep_UA;dep_EO;dep_AA;dep_ET;dep_AG;dep_ES;dep_JC;dep_EF;dep_NA;dep_++;dep_JG;dep_AN;dep_XT;dep_CA;dep_FV;dep_JT;dep_JR;dep_FS;dep_KA;dep_XA;dep_SS;dep_FO;dep_XF;dep_FP;dep_ROOT;dep_OA;dep_TA;dep_HD;dep_DB;dep_SP;dep_OP;dep_OO;dep_PL;dep_CJ;dep_PA;meanDepDistanceDependent;meanDepDistanceSentence;ratioRightDeps;avgSentenceDepth;verbArity0;verbArity1;verbArity2;verbArity3;verbArity4;verbArity5;verbArity6;verbArity7;ratioVerbalRoots;avgVerbalArity;avgNominalPremodifiers;avgNominalPostmodifiers;avgPrepComp;avgWordsPerClause;lixValue;ovixValue;nrValue;name;label\n")
        os.chdir(source)
        c = 0
        for filename in sorted(os.listdir(source)):
            c += 1
#            if c > 0:
#                print(c)
#                print(filename)
#                fv = p.parse_file(filename, swevoc, 'normal')
#                o.write(fv.toCsvOld())
            fv = p.parse_file(filename, swevoc, 'normal')
            o.write(fv.toCsvOld())
            if c % 1000 == 0:
                print(c)
    print(source, "completed")


# Lättläst
        
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/8SIDOR/splitted",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/8SIDOR/8sidor.csv")
#
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/8sidor2006_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/8sidor2006.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/8sidor2007_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/8sidor2007.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/community_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/community.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/fiction_hegas_2_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/fiction_hegas_2.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/fiction_hegas_3_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/fiction_hegas_3.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/fiction_hegas_4_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/fiction_hegas_4.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/fiction_legimus_3-9_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/fiction_legimus_3-9.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/fiction_legimus_10-12_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/fiction_legimus_10-12.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/fiction_legimus_13-19_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/fiction_legimus_13-19.csv")
#parse_directory("/home/johsj47/Desktop/lasbart_organisering/fiction_LL-forlaget_korp",
#                "/home/johsj47/Desktop/lasbart_organisering/fiction_LL-forlaget.csv")
#
## Nyheter
#
##for i in range(9,10):
##    parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/GP/splitted_gp200"+str(i),
##                    "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/GP/gp200"+str(i)+".csv")
##for i in range(10,14):
##    parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/GP/splitted_gp20"+str(i),
##                    "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/GP/gp20"+str(i)+".csv")
#
for i in range(2004,2014):
    parse_directory("/media/johsj47/23E8E28F50B9493D/corpus/GP/splitted_gp"+str(i),
                    "/media/johsj47/23E8E28F50B9493D/corpus/GP/gp"+str(i)+".csv")
#for i in range(2004,2015):
#    parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Webnews/splitted_webbnyheter"+str(i),
#                    "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Webnews/webbnyheter"+str(i)+".csv")
#
## Skönlitteratur
#
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Norstedsromaner 1999/splitted_rom99_20170317",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Norstedsromaner 1999/norstedts.csv")
#
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Bonnierromaner/splitted_romi",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Bonnierromaner/bonnier77-78.csv")
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Bonnierromaner/splitted_romii",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Bonnierromaner/bonnier80-81.csv")
#
## Medicinsk facklitteratur
#
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Smittskydd/splitted_smittskydd_20170405",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Smittskydd/smittskydd.csv")
#
#for i in range(1996, 2007):
#    parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Lakartidningen/splitted_lt"+str(i),
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Lakartidningen/lt"+str(i)+".csv")
#
## Akademisk litteratur
#
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Academic/splitted_sweachum",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Academic/sweachum.csv")
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Academic/splitted_sweacsam",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Academic/sweacsam.csv")
#
## Populärvetenskap
#
#parse_directory("/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Forskning och Framsteg/splitted_fof",
#                "/home/johsj47/Desktop/RESEARCH/corpora/Citatkorpusar/Academic/fof.csv")

