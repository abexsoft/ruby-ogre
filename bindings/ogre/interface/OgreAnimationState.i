%{
#include <OgreAnimationState.h>
%}

%feature("valuewrapper") Ogre::SceneManager::AnimationIterator;
class Ogre::SceneManager::AnimationIterator;
%feature("valuewrapper") Ogre::AnimationStateIterator;
class Ogre::AnimationStateIterator;
%feature("valuewrapper") Ogre::ConstAnimationStateIterator;
class Ogre::ConstAnimationStateIterator;
%feature("valuewrapper") Ogre::ConstEnabledAnimationStateIterator;
class Ogre::ConstEnabledAnimationStateIterator;

%extend Ogre::AnimationStateSet {
	void each_AnimationState() {
		VALUE vstate = Qnil;
		Ogre::AnimationStateIterator iter = self->getAnimationStateIterator();
		while (iter.hasMoreElements()) {
			Ogre::AnimationState* state = iter.getNext();
			vstate = SWIG_NewPointerObj(SWIG_as_voidptr(state), SWIGTYPE_p_Ogre__AnimationState, 0 |  0 );
			rb_yield_values(1, vstate);
		}
	}
}



%include OgreAnimationState.h



