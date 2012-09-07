%{
#include <OgreUTFString.h>
%}

// not supported wchar_t 
#define OGRE_COMPILER OGRE_COMPILER_MSVC

//%rename(DisplayString) Ogre::UTFString;

#ifdef DEBUG_FREEFUNC
%freefunc UTFString "debug_free_UTFString";
#endif

%include "OgreUTFString.h"



%{
 static void debug_free_UTFString(void* ptr) {
	 Ogre::UTFString* string = (Ogre::UTFString*) ptr;
	 
	 std::cout << __PRETTY_FUNCTION__ << ": " << string->asUTF8_c_str() << std::endl;
	 
	 delete string;
 }
%}
