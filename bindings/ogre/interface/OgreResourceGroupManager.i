
%ignore Ogre::ResourceGroupManager::resourceModifiedTime;
%ignore Ogre::ResourceGroupManager::resourceExists;

%{
#include <OgreResourceGroupManager.h>
%}

%feature("valuewrapper") Ogre::ResourceGroupManager::ResourceManagerIterator;
class Ogre::ResourceGroupManager::ResourceManagerIterator;

%nestedworkaround Ogre::ResourceGroupManager::ResourceDeclaration;
%nestedworkaround Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME;

%include OgreResourceGroupManager.h

%{
//	typedef Ogre::ResourceGroupManager::ResourceGroup ResourceGroup;
	typedef Ogre::ResourceGroupManager::ResourceDeclaration ResourceDeclaration;
%}
