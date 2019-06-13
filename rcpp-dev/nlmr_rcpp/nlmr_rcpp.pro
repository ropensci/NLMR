TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

HEADERS += \
    ../../src/rcpp_helper_functions.h \
    ../../src/rcpp_mpd.h \
    ../../src/rcpp_neigh.h

SOURCES += main.cpp \
    ../../src/rcpp_randomrectangularcluster.cpp \
    ../../src/rcpp_mpd.cpp \
    ../../src/rcpp_neigh.cpp

# OpenMP support
QMAKE_CXXFLAGS += -fopenmp
LIBS += -fopenmp

# Adding R, RInside & Rcpp
INCLUDEPATH += /usr/share/R/include
INCLUDEPATH += /usr/lib/R/site-library/Rcpp/include
INCLUDEPATH += /usr/lib/R/site-library/RInside/include/
LIBS += -L/usr/lib -lR
LIBS += -L/usr/lib/R/site-library/RInside/lib -lRInside


