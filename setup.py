#cython: boundscheck=False, wraparound=False, nonecheck=False
#from distutils.core import setup
#from distutils.extension import Extension
#from Cython.Distutils import build_ext
#import numpy
#
#ext_modules=[ Extension("disk_spec",
#              ["disk_spec.pyx"],
#              libraries=["m"],
#              extra_compile_args = ["-ffast-math"],
#              annotate=True)]
#

from distutils.core import setup
from Cython.Build import cythonize
import numpy

setup(
    ext_modules = cythonize("avgrms.pyx", annotate=True,
        compiler_directives={'wraparound': False,
                            'nonecheck': False,
                            'cdivision': True,
                            'boundscheck':False
                            }),
    include_dirs=[numpy.get_include()]
)

