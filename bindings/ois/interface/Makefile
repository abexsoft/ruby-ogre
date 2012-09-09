.PHONY: clean

SWIG = swig
DEPS_DIR = ../../../deps/

include ../../../deps/env.mk

SWIGFLAGS = -ruby -c++ $(OIS_INC)
RUBY = ruby

TARGET = ois_wrap.cpp

all: $(TARGET)

$(TARGET): ois.i
	$(SWIG) $(SWIGFLAGS) -o $@ $<

clean:
	@rm -f $(TARGET)
