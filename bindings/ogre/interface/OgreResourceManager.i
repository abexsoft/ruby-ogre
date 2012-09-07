class ResourcePool : public Pool<ResourcePtr>, public ResourceAlloc
{
protected:
	Ogre::String mName;
public:
	ResourcePool(const Ogre::String& name);
	~ResourcePool();
	/// Get the name of the pool
	const Ogre::String& getName() const;
	void clear();
};

%nestedworkaround MiniatureGarden::Ogre::ResourceManager::ResourcePool;

%{
#include <OgreResourceManager.h>

%}


%feature("valuewrapper") Ogre::ResourceManager::ResourceMapIterator;
class Ogre::ResourceManager::ResourceMapIterator;

%include OgreResourceManager.h

// We've fooled SWIG into thinking that Inner is a global class, so now we need
// to trick the C++ compiler into understanding this apparent global type.
%{
	typedef Ogre::ResourceManager::ResourcePool ResourcePool;
%}
