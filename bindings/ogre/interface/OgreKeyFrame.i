%{
#include <OgreKeyFrame.h>
%}

%nestedworkaround Ogre::VertexPoseKeyFrame::PoseRef;

%include OgreKeyFrame.h

%{

typedef Ogre::VertexPoseKeyFrame::PoseRef PoseRef;
        
%}
