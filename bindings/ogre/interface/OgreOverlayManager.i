%{
#include <OgreOverlayManager.h>
%}

//#ifdef DEBUG_FREEFUNC
%freefunc OverlayManager "debug_free_OverlayManager";
//#endif

%include "OgreOverlayManager.h"

%{
 static void debug_free_OverlayManager(void* ptr) {
	 Ogre::OverlayManager* obj = (Ogre::OverlayManager*) ptr;
	 
	 std::cout << __PRETTY_FUNCTION__ << std::endl;
	 
	 delete obj;
 }
%}

