%{
#include <OgreOverlayContainer.h>
%}

%extend Ogre::OverlayContainer {
	void each_child() {
		VALUE vchild = Qnil;
                Ogre::OverlayContainer::ChildIterator iter = self->getChildIterator();
                while (iter.hasMoreElements()) {
                        Ogre::OverlayElement* child = iter.getNext();
                        vchild = SWIG_NewPointerObj(SWIG_as_voidptr(child), SWIGTYPE_p_Ogre__OverlayElement, 0 |  0 );
                        rb_yield_values(1, vchild);
                }

	}

	void each_child_container() {
		VALUE vchild = Qnil;
                Ogre::OverlayContainer::ChildContainerIterator iter = self->getChildContainerIterator();
                while (iter.hasMoreElements()) {
                        Ogre::OverlayContainer* child = iter.getNext();
                        vchild = SWIG_NewPointerObj(SWIG_as_voidptr(child), SWIGTYPE_p_Ogre__OverlayContainer, 0 |  0 );
                        rb_yield_values(1, vchild);
                }

	}

        static Ogre::OverlayContainer* cast(VALUE value) {
                Ogre::OverlayContainer* obj;
                Data_Get_Struct(value, Ogre::OverlayContainer, obj);
                return obj;
         }
}


%include "OgreOverlayContainer.h"

