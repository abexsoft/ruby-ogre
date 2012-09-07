%{
#include <OgreMovableObject.h>
%}

%feature("valuewrapper") ShadowRenderableListIterator;
class ShadowRenderableListIterator;

%include OgreMovableObject.h

%{
	typedef Ogre::MovableObject::ShadowRenderableListIterator ShadowRenderableListIterator;
%}
