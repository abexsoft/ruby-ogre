# needed DEPS_DIR

### Ogre
OGRE_INC = 
  " -I#{DEPS_DIR}/include/OGRE/" +
  " -I#{DEPS_DIR}/include/OGRE/GLX/" +
  " -I#{DEPS_DIR}/include/OGRE/Paging/" +
  " -I#{DEPS_DIR}/include/OGRE/RTShaderSystem/" +
  " -I#{DEPS_DIR}/include/OGRE/Terrain/"

OGRE_INC += " -I#{DEPS_DIR}/include/ -I#{DEPS_DIR}/include/WIN32" if (/mingw/ =~ RUBY_PLATFORM)

if (/mingw/ =~ RUBY_PLATFORM)
  OGRE_LIB = 
    " -L#{DEPS_DIR}/lib/release" +
    " -lOgreMain -lOgrePaging -lOgreTerrain -lOgreRTShaderSystem -lpthread -Wl,-rpath,./"
else
  OGRE_LIB = 
    " -L#{DEPS_DIR}/lib" +
    " -lOgreMain -lOgrePaging -lOgreTerrain -lOgreRTShaderSystem -lpthread -Wl,-rpath,./"
end


### OIS
OIS_INC = "-I#{DEPS_DIR}/include/OIS"

if (/mingw/ =~ RUBY_PLATFORM)
  OIS_LIB = "-L#{DEPS_DIR}/lib/release -lOIS"
else
  OIS_LIB = "-L#{DEPS_DIR}/lib -lOIS"
end

### Procedural
PROC_INC = "-I#{DEPS_DIR}/include/OgreProcedural" 
PROC_LIB = "-L#{DEPS_DIR}/lib/ -lOgreProcedural"


