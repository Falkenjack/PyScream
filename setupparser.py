#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 25 13:27:44 2017

@author: johsj47
"""

from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("*.pyx")
)