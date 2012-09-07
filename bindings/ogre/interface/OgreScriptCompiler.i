%{
#include <OgreScriptCompiler.h>
%}

%ignore Ogre::ScriptCompiler::addNameExclusion;
%ignore Ogre::ScriptCompiler::removeNameExclusion;

%include OgreScriptCompiler.h

%{
%}
