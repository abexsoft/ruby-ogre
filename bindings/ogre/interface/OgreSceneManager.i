%{
#include <OgreSceneManager.h>
%}

%feature("valuewrapper") Ogre::SceneManager::CameraIterator;
class Ogre::SceneManager::CameraIterator;
%feature("valuewrapper") Ogre::SceneManager::MovableObjectIterator;
class Ogre::SceneManager::MovableObjectIterator;
%feature("valuewrapper") Ogre::InstancedGeometry::BatchInstanceIterator;
class Ogre::InstancedGeometry::BatchInstanceIterator;
%feature("valuewrapper") Ogre::RenderQueueGroup::PriorityMapIterator;
class  Ogre::RenderQueueGroup::PriorityMapIterator;
%feature("valuewrapper") Ogre::RenderQueueGroup::ConstPriorityMapIterator;
class  Ogre::RenderQueueGroup::ConstPriorityMapIterator;

%ignore Ogre::SceneManager::getCameras;
%ignore Ogre::SceneManager::getAnimations;



%extend Ogre::SceneManager {
	virtual Ogre::MovableObject* createMovableObject(const Ogre::String &name, 
							 const Ogre::String &typeName, 
							 VALUE params)
	{
		puts("createMovableObject");
		return NULL;
	}

	virtual Ogre::MovableObject *createMovableObject(const Ogre::String &typeName, 
							 VALUE params)
	{
		Ogre::NameValuePairList pairList;
		VALUE newParams = rb_hash_dup(params);
		while (!RHASH_EMPTY_P(newParams)) {
			VALUE pair = rb_funcall(newParams, rb_intern("shift"), 0);
			VALUE key   = RARRAY_PTR(pair)[0];
			VALUE value = RARRAY_PTR(pair)[1];
			pairList[StringValuePtr(key)] = StringValuePtr(value);
		}

		return self->createMovableObject(typeName, &pairList);
	}
}



%include OgreSceneManager.h


%{
	typedef Ogre::SceneManagerFactory SceneManagerFactory;
	typedef Ogre::SceneManagerMetaData SceneManagerMetaData;
	typedef Ogre::SceneManager::RenderContext RenderContext;
	typedef Ogre::SceneManager::SkyPlaneGenParameters SkyPlaneGenParameters;
	typedef Ogre::SceneManager::SkyBoxGenParameters SkyBoxGenParameters;
	typedef Ogre::SceneManager::SkyDomeGenParameters SkyDomeGenParameters;
	typedef Ogre::SceneManager::SceneMgrQueuedRenderableVisitor SceneMgrQueuedRenderableVisitor;
%}
