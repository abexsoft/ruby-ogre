.PHONY: clean

SWIG = swig
DEPS_DIR = ../../../deps/

include ../../../deps/env.mk

SWIGFLAGS = -ruby -c++ $(PROC_INC) $(OGRE_INC)
RUBY = ruby

TARGET = procedural_wrap.cpp

all: $(TARGET)

$(TARGET): procedural.i
	$(SWIG) $(SWIGFLAGS) -o $@ $<

clean:
	@rm -f $(TARGET)
