%{
#include <OISInputManager.h>
%}

%include OISInputManager.h

%extend OIS::InputManager {
	OIS::Keyboard* createKeyboard(bool bufferMode, const std::string &vendor = "") {
		OIS::Keyboard* key = dynamic_cast<OIS::Keyboard*>(self->createInputObject(OIS::OISKeyboard, bufferMode, vendor));
		return key;
	}
}


%{
	typedef typename OIS::Type Type;
	typedef typename OIS::DeviceList DeviceList;
	typedef typename OIS::Object Object;
	typedef typename OIS::FactoryCreator FactoryCreator;
%}
