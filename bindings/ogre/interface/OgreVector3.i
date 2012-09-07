%{
#include <OgreVector3.h>
%}

// REVISIT: remove temporarily because this returns a wrong vector.
%ignore Ogre::Vector3::ZERO;

%include "OgreVector3.h"

