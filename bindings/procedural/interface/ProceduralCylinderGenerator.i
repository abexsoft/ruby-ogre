%{
#include <ProceduralCylinderGenerator.h>
%}

%template(CylinderMeshGenerator) Procedural::MeshGenerator<Procedural::CylinderGenerator>;

%include ProceduralCylinderGenerator.h

%{
%}


