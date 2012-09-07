%{
#include <OgreShaderGLSLESProgramWriter.h>
%}

// This class is local because of compiling with -fvisibility=hidden.
%ignore Ogre::RTShader::GLSLESProgramWriter;

%include OgreShaderGLSLESProgramWriter.h

%{
%}
