from distutils.core import setup, Extension
from Cython.Build import cythonize
from numpy import get_include  # cimport numpy を使うため

ext = Extension("df_extract", sources=["df_extract.pyx", "df_extractor.c"],
                include_dirs=['./', get_include()])
setup(name="df_extract", ext_modules=cythonize([ext]))
