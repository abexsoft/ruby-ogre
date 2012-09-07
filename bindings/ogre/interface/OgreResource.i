%{
#include <OgreResource.h>
%}

%template(ResourceSharedPtr) Ogre::SharedPtr<Ogre::Resource>;

%include OgreResource.h


