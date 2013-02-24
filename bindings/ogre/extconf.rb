require 'mkmf'
require_relative "../../lib/ruby-ogre"

# set flags
$CFLAGS += " -g #{Ruby::Ogre::get_inc_flags} -I./src"

if (/mingw/ =~ RUBY_PLATFORM)
  $LDFLAGS += " -static-libgcc -static-libstdc++ #{Ruby::Ogre::get_lib_flags} -lws2_32 -lwinmm"
else
  $LDFLAGS += " -static-libgcc -static-libstdc++ #{Ruby::Ogre::get_lib_flags}"
end

$srcs = ["interface/ogre_wrap.cpp"]

$objs = $srcs.collect {|o| o.sub(/\.cpp|\.cc|\.cxx/, ".o")}
$cleanfiles = $objs

create_makefile('ogre')

# comment out ruby gettimeofday() of win32.h on windows.
# comment out ruby struct timezone of missing.h on windows.

