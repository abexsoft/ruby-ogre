%{
#include <OgreShaderExLayeredBlending.h>
%}

// This class is local because of compiling with -fvisibility=hidden.
%ignore Ogre::RTShader::LayeredBlendingFactory;

%include OgreShaderExLayeredBlending.h

%{
%}
