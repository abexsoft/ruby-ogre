%{
#include <OgreShaderFFPRenderStateBuilder.h>
%}

// An argument is a protected class.
%ignore Ogre::RTShader::FFPRenderStateBuilder::buildRenderState;

%include OgreShaderFFPRenderStateBuilder.h

%{
%}
