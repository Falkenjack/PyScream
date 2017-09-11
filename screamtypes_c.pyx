#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 22 15:43:45 2017

@author: johsj47
"""

from pprint import pprint

from collections import Counter, defaultdict
from functions_c import computeLix, computeOvix, computeNominalRatio, divisionOrZero
import numpy as np

cdef:
    set punctuation
    set vowels
    set contentPos
    list posNames
    list depNames


punctuation = set(["PAD", "MID", "MAD"])
vowels = set("aeiouyåäöAEIOUYÅÄÖ")
contentPos = set(['NN', 'JJ', 'AB', 'VB'])
posNames = ['RG', 'CITE', 'JJ', 'DT', 'HS', 'HP', 'RO', 'MID', 'PAD', 'NN', 'VB', 'IE', 'HD', 'MAD', 'IN', 'UO', 'KN', 'HA', 'SN', 'PL', 'PM', 'PN', 'AB', 'PP', 'PS', 'PLQS', 'PC']
depNames = ['VS', 'YY', 'VO', 'DT', 'VG', 'VA', 'I?', 'IC', 'RA', 'IG', 'IF', 'MA', 'AT', 'IK', '+F', 'XX', 'IO', 'IP', 'IQ', 'IR', 'IS', '+A', 'IT', 'IU', 'IV', 'MS', 'PT', 'UA', 'EO', 'AA', 'ET', 'AG', 'ES', 'JC', 'EF', 'NA', '++', 'JG', 'AN', 'XT', 'CA', 'FV', 'JT', 'JR', 'FS', 'KA', 'XA', 'SS', 'FO', 'XF', 'FP', 'ROOT', 'OA', 'TA', 'HD', 'DB', 'SP', 'OP', 'OO', 'PL', 'CJ', 'PA']


#class Document(object):
#    
#        
#    def __init__(self, classValue, swevoc):
#        self.swevoc = swevoc
#        self.swevockeys = self.swevoc.keys()
#        # Counting occurences
#        self._lemmas = []
#        self._tokens = []
#        self._words = []
#        self._posOcc = []
#        self._depOcc = []
##        self._posBFs = []
##        self._depBFs = []
#        self._vbArities = []
#        self._posRoots = []
#        
#        # SweVoc
#        self._svCounts = []
#        self._svTotal = 0
#        
#        # Sentence statistics
#        self._senLens = []
#        self._senDepths = []
##        self._senBFs = []
#        
#        # Document wide single value counters
#        self._noSubCls = 0
#        self._noRightSubCl = 0
#        self._noSents = 0
#        self._noSylls = 0
#        self._noRightDep = 0 #(where dephead>ref)
#        self._noNomPostMod = 0 # number of Nominal Postmodifiers
#        self._noNomPreMod = 0# number of Nominal Premodifiers
#        self._noLixLong = 0
#        self._noPrepComp = 0 # number of Prepositional Complements
#        
#        # Dependency statistics
#        self._depDists = defaultdict(int)
#        self._absDepDists = defaultdict(int)
#
#        # Other
#        self._classValue = classValue
#        self._sentences = []
#        self._sourceText = []
#        self._filename = ''
#        self._metadata = {}
#        
#    def finalize(self):
#        self._noLemmas = len(self._lemmas)
#        self._lemmas = Counter(self._lemmas)
#        self._noUniqLemmas = len(self._lemmas.keys())
#        self._noTokens = len(self._tokens)
#        self._tokens = Counter(self._tokens)
#        self._noUniqTokens = len(self._tokens.keys())
#        self._noWords = len(self._words)
#        self._words = Counter(self._words)
#        self._noUniqWords = len(self._words.keys())
#        self._posOcc = Counter(self._posOcc)
#        self._posOcc.update(Counter({k:0 for k in self.__class__.posNames}))
#        #self._posBFs = Counter(self._posBFs)
#        #self._posBFs.update(Counter({k:0 for k in self.__class__.posNames}))
#        self._noContWords = sum(v for k,v in self._posOcc.items() if k in contentPos)
#        self._noDeps = len(self._depOcc)
#        self._depOcc = Counter(self._depOcc)
#        self._depOcc.update(Counter({k:0 for k in self.__class__.depNames}))
#        #self._depBFs = Counter(self._depBFs)
#        #self._depBFs.update(Counter({k:0 for k in self.__class__.depNames}))
#        self._vbArities = Counter(self._vbArities)
#        self._vbArities.update(Counter({k:0 for k in range(8)}))
#        self._posRoots = Counter(self._posRoots)
#        self._posRoots.update(Counter({k:0 for k in self.__class__.posNames}))
#        self._svCounts = Counter(self._svCounts)
#        self._svCounts.update(Counter({'C':0, 'D':0, 'H':0}))
#        self._totTokenLen = sum(v*len(k) for k, v in self._tokens.items())
#        self._totWordLen = sum(v*len(k) for k, v in self._words.items())
#        self._totDepDist = sum(self._absDepDists.values())
#        
#    def numberOfVerbs(self):
#        return self._posOcc['VB']
#    
#    
#    def addLemma(self, lemma):
#        self._lemmas.append(lemma)
#        swevoc = self.swevoc[lemma]
#        self._svCounts.extend(swevoc)
#        if swevoc:
#            self._svTotal += 1
#    
#    def addToken(self, token):
#        self._tokens.append(token.lower())
#        self._sourceText.append(token)
#        self._noSylls += sum(1 for c in token if c in vowels)
#        if len(token) > 6:
#            self._noLixLong += 1
#        
#    def addDep(self, wordNode):
#        deprel = wordNode.deprel
#        depheadref = wordNode.depheadref
#        ref = wordNode.ref
#        self._depOcc.append(deprel)
#        if depheadref: # i.e. unless word is root
#            depDistance = int(ref) - int(depheadref)
#            if (depDistance > 0):
#                self._noRightDep += 1
#            if deprel == 'UA':
#                self._noSubCls += 1
#                if depDistance > 0:
#                    self._noRightSubCl += 1
#            elif (deprel == "ET"):
#                    self._noNomPostMod += 1
#            elif (deprel == "AT"):
#                    self._noNomPreMod += 1
#            elif (deprel == "PA"):
#                    self._noPrepComp += 1
#            self._absDepDists[deprel] += abs(depDistance)
#            self._depDists[deprel] += depDistance
#    
#    def addWordNode(self, wordNode):
#        self.addToken(wordNode.token)
#        if wordNode.pos not in punctuation:
#            self._words.append(wordNode.token.lower())
#        self.addLemma(wordNode.lemma)
#        self._posOcc.append(wordNode.pos)
#        self.addDep(wordNode)
#    
#    def addSentence(self, sentence):
#        self._noSents += 1
#        self._senDepths.append(sentence.depth)
##        self._senBFs.append(sentence.treeBF)
##        self._posBFs.extend(sentence.posBFs)
##        self._depBF.extend(sentence.depBFs)
#        self._vbArities.extend(sentence.vbArities)
#        self._posRoots.append(sentence.root.pos)
#        self._senLens.append(len(sentence.bow))
#        for wn in sentence.bow:
#            self.addWordNode(wn)

cdef class Document:
    
    cdef:
        object swevoc
        set swevockeys
        list _lemmas
        list _tokens
        list _words
        list _posOcc
        list _depOcc
        list _vbArities
        list _posRoots
        public list _svCounts
        public int _svTotal
        public list _senLens
        public list _senDepths
        public int _noSubCls
        public int _noRightSubCl
        public int _noSents
        public int _noSylls
        public int _noRightDep
        public int _noNomPostMod
        public int _noNomPreMod
        public int _noLixLong
        public int _noPrepComp
        
        public object _depDists
        public object _absDepDists
        
        public str _classValue
        list _sentences
        list _sourceText
        public str _filename
        public dict _metadata
        
        # Finalize
        public int _noLemmas
        public object _lemmaCounts
        public int _noUniqLemmas
        public int _noTokens
        public object _tokenCounts
        public int _noUniqTokens
        public int _noWords
        public object _wordCounts
        public int _noUniqWords
        public object _posOccCounts
        #public object _posBFs
        public int _noContWords
        public int _noDeps
        public object _depOccCounts
        #public object _depBFs
        public object _vbArityCounts
        public object _posRootCounts
        public object _svCountCounts
        public int _totTokenLen
        public int _totWordLen
        public int _totDepDist
        
        
    def __init__(self, str classValue, object swevoc):
        self.swevoc = swevoc
        self.swevockeys = set(self.swevoc.keys())
        # Counting occurences
        self._lemmas = []
        self._tokens = []
        self._words = []
        self._posOcc = []
        self._depOcc = []
#        self._posBFs = []
#        self._depBFs = []
        self._vbArities = []
        self._posRoots = []
        
        # SweVoc
        self._svCounts = []
        self._svTotal = 0
        
        # Sentence statistics
        self._senLens = []
        self._senDepths = []
#        self._senBFs = []
        
        # Document wide single value counters
        self._noSubCls = 0
        self._noRightSubCl = 0
        self._noSents = 0
        self._noSylls = 0
        self._noRightDep = 0 #(where dephead>ref)
        self._noNomPostMod = 0 # number of Nominal Postmodifiers
        self._noNomPreMod = 0# number of Nominal Premodifiers
        self._noLixLong = 0
        self._noPrepComp = 0 # number of Prepositional Complements
        
        # Dependency statistics
        self._depDists = defaultdict(int)
        self._absDepDists = defaultdict(int)

        # Other
        self._classValue = classValue
        self._sentences = []
        self._sourceText = []
        self._filename = ''
        self._metadata = {}
        
    def finalize(self):
        self._noLemmas = len(self._lemmas)
        self._lemmaCounts = Counter(self._lemmas)
        self._noUniqLemmas = len(self._lemmaCounts.keys())
        self._noTokens = len(self._tokens)
        self._tokenCounts = Counter(self._tokens)
        self._noUniqTokens = len(self._tokenCounts.keys())
        self._noWords = len(self._words)
        self._wordCounts = Counter(self._words)
        self._noUniqWords = len(self._wordCounts.keys())
        self._posOccCounts = Counter(self._posOcc)
        self._posOccCounts.update(Counter({k:0 for k in posNames}))
        #self._posBFs = Counter(self._posBFs)
        #self._posBFs.update(Counter({k:0 for k in posNames}))
        self._noContWords = sum(v for k,v in self._posOccCounts.items() if k in contentPos)
        self._noDeps = len(self._depOcc)
        self._depOccCounts = Counter(self._depOcc)
        self._depOccCounts.update(Counter({k:0 for k in depNames}))
        #self._depBFs = Counter(self._depBFs)
        #self._depBFs.update(Counter({k:0 for k in depNames}))
        self._vbArityCounts = Counter(self._vbArities)
        self._vbArityCounts.update(Counter({k:0 for k in range(8)}))
        self._posRootCounts = Counter(self._posRoots)
        self._posRootCounts.update(Counter({k:0 for k in posNames}))
        self._svCountCounts = Counter(self._svCounts)
        self._svCountCounts.update(Counter({'C':0, 'D':0, 'H':0}))
        self._totTokenLen = sum(v*len(k) for k, v in self._tokenCounts.items())
        self._totWordLen = sum(v*len(k) for k, v in self._wordCounts.items())
        self._totDepDist = sum(self._absDepDists.values())
#        print(self._noSents)
        
    def numberOfVerbs(self):
        return self._posOcc['VB']
    
    
    def addLemma(self, lemma):
        self._lemmas.append(lemma)
        cdef list swevoc
        swevoc = self.swevoc[lemma]
        self._svCounts.extend(swevoc)
        if swevoc:
            self._svTotal += 1
    
    def addToken(self, token):
        self._tokens.append(token.lower())
        self._sourceText.append(token)
        self._noSylls += sum(1 for c in token if c in vowels)
        if len(token) > 6:
            self._noLixLong += 1
        
    def addDep(self, wordNode):
        deprel = wordNode.deprel
        depheadref = wordNode.depheadref
        ref = wordNode.ref
        self._depOcc.append(deprel)
        if depheadref: # i.e. unless word is root
            depDistance = int(ref) - int(depheadref)
            if (depDistance > 0):
                self._noRightDep += 1
            if deprel == 'UA':
                self._noSubCls += 1
                if depDistance > 0:
                    self._noRightSubCl += 1
            elif (deprel == "ET"):
                    self._noNomPostMod += 1
            elif (deprel == "AT"):
                    self._noNomPreMod += 1
            elif (deprel == "PA"):
                    self._noPrepComp += 1
            self._absDepDists[deprel] += abs(depDistance)
            self._depDists[deprel] += depDistance
    
    def addWordNode(self, wordNode):
#        print(wordNode.token)
        self.addToken(wordNode.token)
        if wordNode.pos not in punctuation:
            self._words.append(wordNode.token.lower())
        self.addLemma(wordNode.lemma)
        self._posOcc.append(wordNode.pos)
        self.addDep(wordNode)
    
    def addSentence(self, sentence):
        self._noSents += 1
        self._senDepths.append(sentence.depth)
#        self._senBFs.append(sentence.treeBF)
#        self._posBFs.extend(sentence.posBFs)
#        self._depBF.extend(sentence.depBFs)
        self._vbArities.extend(sentence.vbArities)
        self._posRoots.append(sentence.root.pos)
        self._senLens.append(len(sentence.bow))
        for wn in sentence.bow:
            self.addWordNode(wn)
   

     
#class FeatureVector(object):
#    
#    def __init__(self, doc):
#        self.doc = doc
#        self.avgSentenceLength = doc._noWords / doc._noSents
#        self.avgWordLength = doc._totWordLen / doc._noWords
#        self.avgNoSyllables = doc._noSylls / doc._noWords
#        self.sentenceLengthSD = np.std(doc._senLens)
#        self.ratio_svTotal = doc._svTotal / doc._noLemmas
#        self.ratiosSweVoc = {k : v/doc._noWords
#                                for k, v in doc._svCountCounts.items()}
#        self.ratiosPOS = {k : v/doc._noTokens
#                            for k, v in doc._posOccCounts.items()}
#        self.lexicalDensity = doc._noContWords / doc._noWords
#        self.ratiosDep = {k : v/doc._noTokens
#                            for k, v in doc._depOccCounts.items()}
#        self.absDepDistancesDependent = {k : v/doc._depOccCounts[k]
#                                            for k, v in doc._absDepDists.items()}
#        self.absDepDistancesSentence = {k : v/doc._noSents
#                                        for k, v in doc._absDepDists.items()}
#        self.meanDepDistanceDependent = doc._totDepDist / doc._noDeps
#        self.meanDepDistanceSentence = doc._totDepDist / doc._noSents
#        self.ratioRightDeps = doc._noRightDep / doc._noDeps
#        self.avgSentenceDepth = sum(doc._senDepths) / doc._noSents
#        self.sentenceDepthSD = np.std(doc._senDepths)
##        self.avgSentenceBF = sum(doc._senBFs) / doc._noSents
##        self.sentenceBFSD = np.std(doc._senBFs)
#        self.probDistVerbalArity = {k : divisionOrZero(v, doc._posOccCounts['VB'])
#                                    for k, v in doc._vbArityCounts.items()}
#        self.meanVerbalArities = sum([k*v for k, v in self.probDistVerbalArity.items()])
#        self.ratioPosRoots = {k : v / doc._noSents for k, v in doc._posRootCounts.items()}
#        self.ratioSubClauses = doc._noSubCls / doc._noSents
#        self.ratioRightSubClauses = divisionOrZero(doc._noRightSubCl, doc._noSubCls)
#        self.avgNominalPremodifiers = doc._noNomPreMod / doc._noSents
#        self.avgNominalPostmodifiers = doc._noNomPostMod / doc._noSents
#        self.avgPrepComp = doc._noPrepComp / doc._noSents
#        self.avgWordsPerClause = doc._noWords / (doc._noSents + doc._noSubCls)
#        self.lixValue = computeLix(doc._noWords, doc._noSents, doc._noLixLong)
#        self.ovixValue = computeOvix(doc._noWords, doc._noUniqWords)
#        self.nrValue = computeNominalRatio(doc._posOccCounts['NN'],
#                                           doc._posOccCounts['PP'],
#                                           doc._posOccCounts['PC'],
#                                           doc._posOccCounts['PN'],
#                                           doc._posOccCounts['AB'],
#                                           doc._posOccCounts['VB'],
#                                           )
#        self.lvixValue = computeOvix(doc._noLemmas, doc._noUniqLemmas)
#        
#    def toCsvOld(self):
#        res = [self.avgSentenceLength,
#               self.avgWordLength,
#               self.avgNoSyllables,
#               self.ratio_svTotal,
#               self.ratiosSweVoc['C'],
#               self.ratiosSweVoc['D'],
#               self.ratiosSweVoc['H']] + \
#               [self.ratiosPOS[k] for k in posNames] + \
#               [self.lexicalDensity] + \
#               [self.ratiosDep[k] for k in depNames] + \
#               [self.meanDepDistanceDependent,
#               self.meanDepDistanceSentence,
#               self.ratioRightDeps,
#               self.avgSentenceDepth] + \
#               [self.probDistVerbalArity[k] for k in range(8)]+ \
#               [self.ratioPosRoots["VB"],
#               self.meanVerbalArities,
#               self.avgNominalPremodifiers,
#               self.avgNominalPostmodifiers,
#               self.avgPrepComp,
#               self.avgWordsPerClause,
#               self.lixValue,
#               self.ovixValue,
#               self.nrValue,
#               self.doc._filename,
#               self.doc._classValue,
#               '\n']
#        return ','.join([str(i) for i in res])
        
cdef class FeatureVector:
    
    cdef:
#        object doc
        double avgSentenceLength
        double avgWordLength
        double avgNoSyllables
        double sentenceLengthSD
        double ratio_svTotal
        dict ratiosSweVoc
        readonly dict ratiosPOS
        double lexicalDensity
        dict ratiosDep
#        dict absDepDistancesDependent
#        dict absDepDistancesSentence
        double meanDepDistanceDependent
        double meanDepDistanceSentence
        double ratioRightDeps
        double avgSentenceDepth
        double sentenceDepthSD
        dict probDistVerbalArity
        double meanVerbalArities
        dict ratioPosRoots
        double ratioSubClauses
        double ratioRightSubClauses
        double avgNominalPremodifiers
        double avgNominalPostmodifiers
        double avgPrepComp
        double avgWordsPerClause
        double lixValue
        double ovixValue
        double nrValue
#        double lvixValue
        str filename
        str classValue
    
    def __init__(self, object doc):
#        self.doc = doc
        self.avgSentenceLength = doc._noWords / doc._noSents
        self.avgWordLength = doc._totWordLen / doc._noWords
        self.avgNoSyllables = doc._noSylls / doc._noWords
        self.sentenceLengthSD = np.std(doc._senLens)
        self.ratio_svTotal = doc._svTotal / doc._noLemmas
        self.ratiosSweVoc = {k : v/doc._noWords
                                for k, v in doc._svCountCounts.items()}
        self.ratiosPOS = {k : v/doc._noTokens
                            for k, v in doc._posOccCounts.items()}
        self.lexicalDensity = doc._noContWords / doc._noWords
        self.ratiosDep = {k : v/doc._noTokens
                            for k, v in doc._depOccCounts.items()}
#        self.absDepDistancesDependent = {k : v/doc._depOccCounts[k]
#                                            for k, v in doc._absDepDists.items()}
#        self.absDepDistancesSentence = {k : v/doc._noSents
#                                        for k, v in doc._absDepDists.items()}
        self.meanDepDistanceDependent = doc._totDepDist / doc._noDeps
        self.meanDepDistanceSentence = doc._totDepDist / doc._noSents
        self.ratioRightDeps = doc._noRightDep / doc._noDeps
        self.avgSentenceDepth = sum(doc._senDepths) / doc._noSents
        self.sentenceDepthSD = np.std(doc._senDepths)
#        self.avgSentenceBF = sum(doc._senBFs) / doc._noSents
#        self.sentenceBFSD = np.std(doc._senBFs)
        self.probDistVerbalArity = {k : divisionOrZero(v, doc._posOccCounts['VB'])
                                    for k, v in doc._vbArityCounts.items()}
        self.meanVerbalArities = sum([k*v for k, v in self.probDistVerbalArity.items()])
        self.ratioPosRoots = {k : v / doc._noSents for k, v in doc._posRootCounts.items()}
        self.ratioSubClauses = doc._noSubCls / doc._noSents
        self.ratioRightSubClauses = divisionOrZero(doc._noRightSubCl, doc._noSubCls)
        self.avgNominalPremodifiers = doc._noNomPreMod / doc._noSents
        self.avgNominalPostmodifiers = doc._noNomPostMod / doc._noSents
        self.avgPrepComp = doc._noPrepComp / doc._noSents
        self.avgWordsPerClause = doc._noWords / (doc._noSents + doc._noSubCls)
        self.lixValue = computeLix(doc._noWords, doc._noSents, doc._noLixLong)
        self.ovixValue = computeOvix(doc._noWords, doc._noUniqWords)
        self.nrValue = computeNominalRatio(doc._posOccCounts['NN'],
                                           doc._posOccCounts['PP'],
                                           doc._posOccCounts['PC'],
                                           doc._posOccCounts['PN'],
                                           doc._posOccCounts['AB'],
                                           doc._posOccCounts['VB'],
                                           )
        self.filename = doc._filename
        self.classValue = doc._classValue
#        self.lvixValue = computeOvix(doc._noLemmas, doc._noUniqLemmas)
        
    def toCsvOld(self):
        res = [self.avgSentenceLength,
               self.avgWordLength,
               self.avgNoSyllables,
               self.ratio_svTotal,
               self.ratiosSweVoc['C'],
               self.ratiosSweVoc['D'],
               self.ratiosSweVoc['H']] + \
               [self.ratiosPOS[k] for k in posNames] + \
               [self.lexicalDensity] + \
               [self.ratiosDep[k] for k in depNames] + \
               [self.meanDepDistanceDependent,
               self.meanDepDistanceSentence,
               self.ratioRightDeps,
               self.avgSentenceDepth] + \
               [self.probDistVerbalArity[k] for k in range(8)]+ \
               [self.ratioPosRoots["VB"],
               self.meanVerbalArities,
               self.avgNominalPremodifiers,
               self.avgNominalPostmodifiers,
               self.avgPrepComp,
               self.avgWordsPerClause,
               self.lixValue,
               self.ovixValue,
               self.nrValue,
               self.filename,
               self.classValue,
               '\n']
        return ','.join([str(i) for i in res])
        
#class Sentence(object):
#    
#    def __init__(self):
#        self.bow = []
#        self.root = None
#        self.non_root = set()
#        
#    def finalize(self):
#        self.buildTree(self.root)
#        self.depth = self.root.depth()
#        self.treeBF = sum(len(wn.children) for wn in self.bow)/len(self.bow)
#        self.posBF = Counter()
#        for wn in self.bow:
#            self.posBF.update({wn.pos : len(wn.children)})
#        self.depBF = Counter()
#        for wn in self.bow:
#            self.depBF.update({wn.deprel : len(wn.children)})
#        self.vbArities = Counter(len(w.children) for w in self.bow if w.pos == 'VB')
#    
#    def buildTree(self, head):
#        #pprint(dir(self.bow))
#        #print(len(self.v))
#        for candidate in self.non_root:
#            if candidate.depheadref == head.ref:
#                candidate.dephead = head
#                head.children.append(candidate)
#                #self.non_root.remove(candidate)
#        for child in head.children:
#            self.buildTree(child)
#        
#    def addWordNode(self, wn):
#        self.bow.append(wn)
#        if wn.depheadref == 0 or wn.depheadref == None or wn.depheadref == '' or wn.deprel =='ROOT':
#            self.root = wn
#        else:
#            self.non_root.add(wn)
        
cdef class Sentence:
    
    cdef:
        readonly object bow
        readonly WordNode root
        object non_root
        readonly int depth
#        readonly double treeBF
#        readonly list posBFs
#        readonly list depBFs
        readonly object vbArities
    
    def __init__(self):
        self.bow = []
        self.root = None
        self.non_root = []
        
    cpdef finalize(self):
        self.buildTree(self.root)
        self.depth = self.root.depth()
#        self.treeBF = sum([len(wn.children) for wn in self.bow])/len(self.bow)
#        for i in range(len(self.bow)):
#            self.posBFs.extend([self.bow[i].pos] * len(self.bow[i].children))
#            self.depBFs.extend([self.bow[i].deprel] * len(self.bow[i].children))
        self.vbArities = Counter([len(w.children) for w in self.bow if w.pos == 'VB'])
    
    cdef buildTree(self, head):
        cdef WordNode candidate
        #pprint(dir(self.bow))
        #print(len(self.v))
        for i in range(len(self.non_root)):
            candidate = self.non_root[i]
            if candidate.depheadref == head.ref:
                candidate.dephead = head
                head.children.append(candidate)
                #self.non_root.remove(candidate)
        for child in head.children:
            self.buildTree(child)
        
    cpdef addWordNode(self, wn):
        self.bow.append(wn)
        if wn.depheadref == 0 or wn.depheadref == None or wn.depheadref == '' or wn.deprel =='ROOT':
            self.root = wn
        else:
            self.non_root.append(wn)
        
        
#class WordNode(object):
#    
#    quotes = set(["'","\"","“","”","‘","’"])
#    
##    def __init__(self, token, pos, lemma, deprel, ref, depheadref = None):
##        self.token = token
##        if pos == "PAD" and token in self.__class__.quotes:
##            self.pos = "CITE"
##        else:
##            self.pos = pos
##        if lemma == "":
##            lemma = "#UNKNOWN_LEMMA#"
##        self.lemma = lemma
##        self.deprel = deprel
##        self.ref = ref
##        self.depheadref = depheadref
##        self.children = []
##        self.dephead = None
#        
#    def __init__(self, elem, xml=None):
#        self.xml = xml
#        self.token = elem.text
#        if elem.get("pos") == "PAD" and self.token in self.__class__.quotes:
#            self.pos = "CITE"
#        else:
#            self.pos = elem.get("pos")
#        lemma = elem.get("lemma").replace('|', '')
#        if lemma == "":
#            lemma = "#UNKNOWN_LEMMA#"
#        self.lemma = lemma
#        self.deprel = elem.get("deprel")
#        self.ref = int(elem.get("ref"))
#        self.depheadref = elem.get("dephead")
#        self.children = []
#        self.dephead = None
#    
#    def depth(self):
#        if self.children == []:
#            return 1
#        else:
#            return 1 + max(c.depth() for c in self.children)
#
quotes = set(["'","\"","“","”","‘","’"])

cdef class WordNode:
    
    cdef:
        readonly str token
        readonly str pos
        readonly str lemma
        readonly str deprel
        readonly int ref
        readonly int depheadref
        int child_count
        public list children
        public object dephead
        
    def __init__(self, object elem):
        cdef str lemma
        self.token = elem.text
        if elem.get("pos") == "PAD" and self.token in quotes:
            self.pos = "CITE"
        else:
            self.pos = elem.get("pos")
        lemma = elem.get("lemma").replace('|', '')
        if lemma == "":
            lemma = "#UNKNOWN_LEMMA#"
        self.lemma = lemma
        self.deprel = elem.get("deprel")
        self.ref = int(elem.get("ref"))
        if elem.get("dephead"):
            self.depheadref = int(elem.get("dephead"))
        else:
            self.depheadref = 0
        self.child_count = 0
        self.children = []
        
    cpdef void addChild(self, object child):
        self.children.append(child)
        self.child_count += 1

    cpdef void setHead(self, object head):
        self.dephead = head
        
    cpdef int depth(self):
        cdef int maximum, d
        if self.child_count == 0:
            return 1
        else:
            maximum = 0
            for i in range(self.child_count):
                d = self.children[i].depth()
                if d > maximum:
                    maximum = d
            return maximum
#        
#        
        
        
        
        
        
        