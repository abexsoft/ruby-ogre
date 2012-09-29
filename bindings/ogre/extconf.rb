require 'mkmf'

DEPS_DIR = "../../deps/"

# set values of INC and LIB.
load "#{DEPS_DIR}/env.rb"

# set flags
$CFLAGS += " -g " + OGRE_INC + " -I./src"

if (/mingw/ =~ RUBY_PLATFORM)
  $LDFLAGS += " -static-libgcc -static-libstdc++ " + OGRE_LIB + " -lws2_32 -lwinmm"
else
  $LDFLAGS += " -static-libgcc -static-libstdc++ " + OGRE_LIB
end

$srcs = ["interface/ogre_wrap.cpp"]

$objs = $srcs.collect {|o| o.sub(/\.cpp|\.cc|\.cxx/, ".o")}
$cleanfiles = $objs

create_makefile('ogre')

# comment out ruby gettimeofday() of win32.h on windows.
# comment out ruby struct timezone of missing.h on windows.

