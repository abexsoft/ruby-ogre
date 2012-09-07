%{
#include <OgreCommon.h>
%}

// NameValuePairList changes into Ruby::Array because it's difficult to convert and be matched the type in C++, 
// especially a kind of typedef *::type.
//%template(NameValuePairList) std::map<Ogre::String, Ogre::String, 
//std::less<Ogre::String> STLAllocator<std::pair<const Ogre::String, Ogre::String>, GeneralAllocPolicy> >;

%include OgreCommon.h


