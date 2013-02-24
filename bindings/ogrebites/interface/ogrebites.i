%module(directors="1") "ogrebites"

#define _OgreExport
#define OGRE_AUTO_MUTEX
#define OGRE_MUTEX(arg)
#define OGRE_AUTO_SHARED_MUTEX

%{
#include <OIS.h>
#include <Ogre.h>
%}


%include cpointer.i
%pointer_class(int, Intp);

%include std_string.i
%include std_pair.i
%include std_map.i
%include std_multimap.i

%import ogre_all.i
%import ois_all.i

%include SdkTrays.i
%include SdkCameraMan.i
