require 'mkmf'

DEPS_DIR = "../../deps"

# set values of INC and LIB.
load "#{DEPS_DIR}/env.rb"

# set flags
$CFLAGS += " -g " + OIS_INC

if (/mingw/ =~ RUBY_PLATFORM)
  $LDFLAGS += " -static-libgcc -static-libstdc++ " + OIS_LIB + " -lws2_32 -lwinmm"
else
  $LDFLAGS += " -static-libgcc -static-libstdc++ " + OIS_LIB
end

$srcs = ["interface/ois_wrap.cpp"]
$objs = $srcs.collect {|o| o.sub(/\.cpp|\.cc|\.cxx/, ".o")}
$cleanfiles = $objs

create_makefile('ois')
