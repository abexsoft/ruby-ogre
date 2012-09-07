%{
#include <OgreAlignedAllocator.h>
%}

%ignore Ogre::AlignedMemory::allocate;

%include OgreAlignedAllocator.h

%{
%}
