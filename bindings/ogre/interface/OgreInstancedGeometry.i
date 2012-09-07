%{
#include <OgreInstancedGeometry.h>
%}

%feature("valuewrapper") Ogre::InstancedGeometry::BatchInstanceIterator;
class Ogre::InstancedGeometry::BatchInstanceIterator;

%include OgreInstancedGeometry.h

