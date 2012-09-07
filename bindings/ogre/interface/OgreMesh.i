%{
#include <OgreMesh.h>
%}

//%ignore Ogre::SharedPtr<Ogre::Mesh>::getPoseIterator;
%ignore getPoseIterator;
%template(MeshSharedPtr) Ogre::SharedPtr<Ogre::Mesh>;


%include OgreMesh.h

