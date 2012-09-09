%{
#include <SdkTrays.h>
%}

%feature("director") OgreBites::SdkTrayListener;

//#ifdef DEBUG_FREEFUNC
%freefunc SdkTrayManager "debug_free_SdkTrayManager";
//#endif

%extend OgreBites::SelectMenu {
	void setItems(VALUE items) {
		Ogre::StringVector itemVector;

		int size = RARRAY_LEN(items);
		for (int i = 0; i < size; i++) {
			VALUE item = RARRAY_PTR(items)[i];
			itemVector.push_back(Ogre::String(StringValuePtr(item)));
		}
		self->setItems(itemVector);
	}
        static OgreBites::SelectMenu* cast(VALUE value) {
                OgreBites::SelectMenu* obj;
                Data_Get_Struct(value, OgreBites::SelectMenu, obj);
                return obj;
         }
}

%extend OgreBites::SdkTrayManager {

	OgreBites::ParamsPanel* createParamsPanel(OgreBites::TrayLocation trayLoc, 
						  const Ogre::String& name, 
						  Ogre::Real width,
						  VALUE paramNames){
		Ogre::StringVector itemVector;

		int size = RARRAY_LEN(paramNames);
		for (int i = 0; i < size; i++) {
			VALUE item = RARRAY_PTR(paramNames)[i];
			itemVector.push_back(Ogre::String(StringValuePtr(item)));
		}
		return self->createParamsPanel(trayLoc, name, width, itemVector);
	}
}



%include "SdkTrays.h"

%{
 static void debug_free_SdkTrayManager(void* ptr) {
	 OgreBites::SdkTrayManager* obj = (OgreBites::SdkTrayManager*) ptr;
	 
	 std::cout << __PRETTY_FUNCTION__ << std::endl;
	 
	 delete obj;
 }
%}


