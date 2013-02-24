require 'mkmf'
require "ruby-ois"
require_relative "../../lib/ruby-ogre"

# set flags
$CFLAGS += " -g #{Ruby::Ogre::get_inc_flags} #{Ruby::Ois::get_inc_flags}"

if (/mingw/ =~ RUBY_PLATFORM)
  $LDFLAGS += " -static-libgcc -static-libstdc++ #{Ruby::Ogre::get_lib_flags} -lws2_32 -lwinmm"
else
  $LDFLAGS += " -static-libgcc -static-libstdc++ #{Ruby::Ogre::get_lib_flags}"
end

$srcs = ["interface/ogrebites_wrap.cpp"]

$objs = $srcs.collect {|o| o.sub(/\.cpp|\.cc|\.cxx/, ".o")}
$cleanfiles = $objs

create_makefile('ogrebites')
