%{
#include <OgreTechnique.h>
%}

%nestedworkaround Ogre::Technique::GPUVendorRule;
%nestedworkaround Ogre::Technique::GPUDeviceNameRule;

%include "OgreTechnique.h"


%{

typedef Ogre::Technique::GPUVendorRule GPUVendorRule;
typedef Ogre::Technique::GPUDeviceNameRule GPUDeviceNameRule;

	
%}

