%module(directors="1") "Procedural"

#define _ProceduralExport

%import ../../ogre/interface/ogre_all.i

%include cpointer.i
%pointer_class(int, Intp);

%include ProceduralPlatform.i
%include ProceduralRoot.i
%include ProceduralUtils.i
%include ProceduralTriangleBuffer.i
%include ProceduralMeshGenerator.i
%include ProceduralBoxGenerator.i
%include ProceduralCapsuleGenerator.i
%include ProceduralConeGenerator.i
%include ProceduralCylinderGenerator.i
%include ProceduralIcoSphereGenerator.i
%include ProceduralMultiShape.i
%include ProceduralPlaneGenerator.i
%include ProceduralRoundedBoxGenerator.i
%include ProceduralSphereGenerator.i
%include ProceduralTorusGenerator.i
%include ProceduralTorusKnotGenerator.i
%include ProceduralTubeGenerator.i
%include ProceduralTrack.i
%include ProceduralShape.i
%include ProceduralSplines.i
%include ProceduralShapeGenerators.i
%include ProceduralGeometryHelpers.i
%include ProceduralLathe.i
%include ProceduralPath.i
%include ProceduralPathGenerators.i
%include ProceduralExtruder.i
%include ProceduralStableHeaders.i
%include ProceduralTriangulator.i
%include ProceduralHeader.i

%{
%}
