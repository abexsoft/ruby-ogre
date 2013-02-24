require_relative "ruby-ogre/version"

module Ruby
  module Ogre
    def self.get_top_path
      File.dirname(File.dirname(File.expand_path(__FILE__)))
    end

    def self.get_deps_lib_path
      "#{get_top_path}/deps/lib"
    end

    def self.get_deps_inc_path
      "#{get_top_path()}/deps/include"
    end

    def self.get_inc_flags
      flags = "-I#{get_top_path}/deps/include/OGRE/ " +
        "-I#{get_top_path}/deps/include/OGRE/GLX/ " +
        "-I#{get_top_path}/deps/include/OGRE/Paging/ " +
        "-I#{get_top_path}/deps/include/OGRE/RTShaderSystem/ " +
        "-I#{get_top_path}/deps/include/OGRE/Terrain "

      if (/mingw/ =~ RUBY_PLATFORM)
        flags += " -I#{get_top_path}/deps/include/ -I#{get_top_path}/deps/include/WIN32" 
      end

      return flags
    end

    def self.get_lib_flags
      flags = " -lOgreMain -lOgrePaging -lOgreTerrain -lOgreRTShaderSystem"
      flags += " -lpthread -Wl,-rpath,./"

      if (/mingw/ =~ RUBY_PLATFORM)
        flags =  " -L#{get_top_path}/deps/lib/release" + flags
      else
        flags = " -L#{get_top_path}/deps/lib" + flags
      end

      return flags
    end

    def self.get_lib_path
      File.dirname(File.expand_path(__FILE__))
    end

    def self.get_plugin_folder
      "#{get_top_path()}/deps/lib/OGRE"
    end

    def self.get_resource_folder
      "#{get_top_path()}/deps/share/OGRE/media/"
    end
    
  end
end
