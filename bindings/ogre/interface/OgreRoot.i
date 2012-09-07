%{
#include <OgreRoot.h>
%}

%feature("valuewrapper") Ogre::Root::MovableObjectFactoryIterator;
class Ogre::Root::MovableObjectFactoryIterator;

//%ignore Ogre::Root::getAvailableRenderers;

%extend Ogre::Root {
	VALUE getAvailableRendererArray(void) {
		VALUE ary = rb_ary_new();

		Ogre::RenderSystemList rsList = self->getAvailableRenderers();
		for (unsigned int i = 0; i < rsList.size(); i++) {
			VALUE rs = SWIG_NewPointerObj(SWIG_as_voidptr(rsList[i]), SWIGTYPE_p_Ogre__RenderSystem, 0 |  0 );
			rb_ary_push(ary, rs);
		}
		return ary;
	}
	void destruct() {
		delete self;
		self = NULL;
	}
}


//#ifdef DEBUG_FREEFUNC
%freefunc Ogre::Root "debug_free_Root";
//#endif


%include OgreRoot.h

%{
static void debug_free_Root(void* ptr) {
	Ogre::Root* obj = (Ogre::Root*) ptr;
	
	std::cout << __PRETTY_FUNCTION__ << std::endl;
	 
//	 delete obj;
 }
%}

