%{
#include <OgreGpuProgramParams.h>
%}


%nestedworkaround Ogre::GpuProgramParameters::AutoConstantEntry;

%include OgreGpuProgramParams.h

%{
typedef Ogre::GpuProgramParameters::AutoConstantEntry  AutoConstantEntry;

%}
