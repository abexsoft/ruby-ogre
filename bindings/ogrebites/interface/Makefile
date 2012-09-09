.PHONY: clean

SWIG = swig
DEPS_DIR = ../../../deps/

include ../../../deps/env.mk

SWIGFLAGS = -ruby -c++ $(OIS_INC) $(OGRE_INC)
RUBY = ruby

TARGET = ogrebites_wrap.cpp

all: $(TARGET)

$(TARGET): ogrebites.i
	$(SWIG) $(SWIGFLAGS) -o $@ $<

clean:
	@rm -f $(TARGET)
