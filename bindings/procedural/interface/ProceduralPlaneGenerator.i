%{
#include <ProceduralPlaneGenerator.h>
%}

%template(PlaneMeshGenerator) Procedural::MeshGenerator<Procedural::PlaneGenerator>;

%include ProceduralPlaneGenerator.h

%{
%}


