%{
#include <OgrePanelOverlayElement.h>
%}

%extend Ogre::PanelOverlayElement {
        static Ogre::PanelOverlayElement* cast(VALUE value) {
                Ogre::PanelOverlayElement* obj;
                Data_Get_Struct(value, Ogre::PanelOverlayElement, obj);
                return obj;
         }
}

%include "OgrePanelOverlayElement.h"

