%{
#include <OgreTerrain.h>
%}

%nestedworkaround Ogre::Terrain::LayerInstance;
%nestedworkaround Ogre::Terrain::ImportData;

%include OgreTerrain.h


%{
typedef Ogre::Terrain::LayerInstance LayerInstance;
typedef Ogre::Terrain::ImportData ImportData;
%}
