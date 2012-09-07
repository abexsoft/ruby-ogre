%{
#include <OgreSceneManagerEnumerator.h>
%}

%feature("valuewrapper") Ogre::SceneManagerEnumerator::MetaDataIterator;
class Ogre::SceneManagerEnumerator::MetaDataIterator;
%feature("valuewrapper") Ogre::SceneManagerEnumerator::SceneManagerIterator;
class Ogre::SceneManagerEnumerator::SceneManagerIterator;

%include OgreSceneManagerEnumerator.h

