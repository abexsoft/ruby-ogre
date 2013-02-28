require 'rake/clean'
require 'ruby-ois'

desc "Download a ruby-ogre gem from bitbucket."
task :default do
  require 'open-uri'

  UPLOAD_SITE="http://cdn.bitbucket.org/abexsoft/ruby-ogre/downloads"
  RUBY_OGRE_GEM="ruby-ogre-0.1.0-x86-linux.gem"

  puts "Downloading #{RUBY_OGRE_GEM} from #{UPLOAD_SITE}..."
  File.open("#{RUBY_OGRE_GEM}", "wb") do |gem_file|
    open("#{UPLOAD_SITE}/#{RUBY_OGRE_GEM}", 'rb') do |read_file|
      gem_file.write(read_file.read)
    end
  end

  puts "Installing #{RUBY_OGRE_GEM}..."
  system("gem install #{RUBY_OGRE_GEM}")
end

desc "Download a ogre source."
task :download do
  FileUtils::mkdir_p("deps/src")
  chdir('deps/src') {
    if /mingw/ =~ RUBY_PLATFORM
      sh "wget http://sourceforge.net/projects/ogre/files/ogre/1.8/1.8.0/OgreSDK_MinGW_v1-8-0.exe"
      sh "OgreSDK_MinGW_v1-8-0.exe"
      sh "cp -a OgreSDK_MinGW_v1-8-0/include ../"
      sh "cp -a OgreSDK_MinGW_v1-8-0/boost/boost ../include"
      sh "cp -a OgreSDK_MinGW_v1-8-0/lib ../"
      sh "cp -a OgreSDK_MinGW_v1-8-0/boost/lib/* ../lib"
    else
      OGRE_FILE="ogre_src_v1-8-1.tar.bz2"
      sh "wget http://sourceforge.net/projects/ogre/files/ogre/1.8/1.8.1/#{OGRE_FILE}"
      sh "tar xjvf #{OGRE_FILE}"
    end
  }
end

desc "Compile ogre libraries."
task :compile do
  unless /mingw/ =~ RUBY_PLATFORM
    chdir("deps/src/ogre_src_v1-8-1/") {
      sh "cmake -DCMAKE_INSTALL_PREFIX:PATH=../.. -DOGRE_INSTALL_SAMPLES:BOOL=ON -DOIS_INCLUDE_DIR:PATH=#{Ruby::Ois::get_top_path}/deps/include/OIS -DOIS_LIBRARY_DBG:FILEPATH=#{Ruby::Ois::get_top_path}/deps/lib/libOIS.so -DOIS_LIBRARY_REL:FILEPATH=#{Ruby::Ois::get_top_path}/deps/lib/libOIS.so -DCMAKE_MODULE_LINKER_FLAGS:STRING='-static-libgcc -static-libstdc++' -DCMAKE_SHARED_LINKER_FLAGS:STRING='-static-libgcc -static-libstdc++'"
      sh "make -j4 && make install"
    }
  end
end

#
# Compile extensions
#
DLEXT = RbConfig::MAKEFILE_CONFIG['DLEXT']

## lib/*.#{DLEXT}
file "lib/ogre.#{DLEXT}" => "bindings/ogre/ogre.#{DLEXT}" do |f|
  cp f.prerequisites, "lib/", :preserve => true
end

file "lib/ogrebites.#{DLEXT}" => "bindings/ogrebites/ogrebites.#{DLEXT}" do |f|
  cp f.prerequisites, "lib/", :preserve => true
end

## ext/**/*.#{DLEXT}
file "bindings/ogre/ogre.#{DLEXT}" => FileList["bindings/ogre/Makefile"] do |f|
  sh 'cd bindings/ogre/ && make clean && make'
end
CLEAN.include 'bindings/ogre/*.{o,so,dll}'
    
file "bindings/ogrebites/ogrebites.#{DLEXT}" => FileList["bindings/ogrebites/Makefile"] do |f|
  sh 'cd bindings/ogrebites && make clean && make'
end
CLEAN.include 'bindings/ogrebites/*.{o,so,dll}'
    
## ext/**/Makefile
file 'bindings/ogre/Makefile' => FileList['bindings/ogre/interface/ogre_wrap.cpp'] do
  chdir('bindings/ogre/') { ruby 'extconf.rb' }
end
CLEAN.include 'bindings/ogre/Makefile'

file 'bindings/ogrebites/Makefile' => FileList['bindings/ogrebites/interface/ogrebites_wrap.cpp'] do
  chdir('bindings/ogrebites/') { ruby 'extconf.rb' }
end
CLEAN.include 'bindings/ogrebites/Makefile'
    
## make wrappers with swig.
file 'bindings/ogre/interface/ogre_wrap.cpp' do
  chdir('bindings/ogre/interface') { sh 'rake' }
end
CLEAN.include 'bindings/ogre/interface/ogre_wrap.{cpp,h,o}'
    
file 'bindings/ogrebites/interface/ogrebites_wrap.cpp' do
  chdir('bindings/ogrebites/interface') { sh 'rake' }
end
CLEAN.include 'bindings/ogrebites/interface/ogrebites_wrap.{cpp,h,o}'

desc "Compile all of extension libraries."
task :build => ["lib/ogre.#{DLEXT}", "lib/ogrebites.#{DLEXT}"]

#
# Document
#
desc 'Create documents'
task :doc => ['bindings/ogre/interface/ogre_wrap.cpp',
              'bindings/ogrebites/interface/ogrebites_wrap.cpp'] do |f|
  sh "rdoc #{f.prerequisites.join(' ')}"
end

