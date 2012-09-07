%{
#include <OgreRibbonTrail.h>
%}


%extend Ogre::RibbonTrail {
        static Ogre::RibbonTrail* cast(VALUE value) {
                Ogre::RibbonTrail* obj;
                Data_Get_Struct(value, Ogre::RibbonTrail, obj);
                return obj;
         }
}

%include "OgreRibbonTrail.h"



