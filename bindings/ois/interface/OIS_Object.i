%{
#include <OISObject.h>
#include <OISKeyboard.h>
#include <OISMouse.h>
%}

%extend OIS::Object{
	OIS::Keyboard *toKeyboard() {
		OIS::Keyboard* key = dynamic_cast<OIS::Keyboard*>(self);
		return key;
	}
	OIS::Mouse *toMouse() {
		OIS::Mouse* key = dynamic_cast<OIS::Mouse*>(self);
		return key;
	}
}


%include OISObject.h

%{
%}
