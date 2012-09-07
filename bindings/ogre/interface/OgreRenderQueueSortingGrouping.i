%{
#include <OgreRenderQueueSortingGrouping.h>
%}

%feature("valuewrapper") Ogre::RenderQueueGroup::PriorityMapIterator;
class Ogre::RenderQueueGroup::PriorityMapIterator;
%feature("valuewrapper") Ogre::RenderQueueGroup::ConstPriorityMapIterator;
class Ogre::RenderQueueGroup::ConstPriorityMapIterator;

%include OgreRenderQueueSortingGrouping.h

