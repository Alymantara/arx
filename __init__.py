#!/usr/bin/env python
# -*- coding: utf-8 -*-

#from __future__ import (division, print_function, absolute_import,
#                        unicode_literals)
#from .sampler import *
#from .mh import *
#from .ensemble import *
#from .ptsampler import *
#from . import utils

__modules__ = ['avgrms']
from .avgrms.avgrms import avgrmsx

__version__ = "0.2.0"

# How to Compile
# /Users/juan/miniconda3/bin/python setup.py build_ext --inplace
#

# x = arange(100,1e5,2)
