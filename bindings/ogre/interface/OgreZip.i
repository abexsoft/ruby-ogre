%{
#include <OgreZip.h>
%}

// becase ZipArchiveFactory can't be linked well.
%ignore Ogre::ZipArchiveFactory;
%ignore Ogre::ZipDataStream;

%include OgreZip.h

%{
%}
