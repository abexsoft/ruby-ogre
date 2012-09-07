%{
#include <OgreMaterial.h>
%}

%template(MaterialSharedPtr) Ogre::SharedPtr<Ogre::Material>;

%extend Ogre::Material {
	static Ogre::Material* cast(VALUE value) {
		Ogre::Material* obj;
                Data_Get_Struct(value, Ogre::Material, obj);
                return obj;
	}
}


%include "OgreMaterial.h"

