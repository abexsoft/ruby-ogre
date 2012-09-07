%{
#include <OgreBorderPanelOverlayElement.h>
%}

%extend Ogre::BorderPanelOverlayElement {
	static Ogre::BorderPanelOverlayElement* cast(VALUE value) {
		Ogre::BorderPanelOverlayElement* obj;
		Data_Get_Struct(value, Ogre::BorderPanelOverlayElement, obj);
		return obj;
	 }
 }

%include "OgreBorderPanelOverlayElement.h"

