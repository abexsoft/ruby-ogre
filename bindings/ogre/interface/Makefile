.PHONY: clean

SWIG = swig
DEPS_DIR = ../../../deps/

include ../../../deps/env.mk

SWIGFLAGS = -ruby -c++ $(OGRE_INC) -I../src
RUBY = ruby

TARGET = ogre_wrap.cpp

all: $(TARGET)

$(TARGET): ogre.i
	$(SWIG) $(SWIGFLAGS) -o $@ $<

clean:
	@rm -f $(TARGET)
