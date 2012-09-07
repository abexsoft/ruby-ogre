%{
#include <OgreSceneNode.h>
%}

%ignore Ogre::SceneNode::getAttachedObjectIterator;
%ignore Ogre::SceneNode::getChildIterator;

%include "OgreSceneNode.h"

