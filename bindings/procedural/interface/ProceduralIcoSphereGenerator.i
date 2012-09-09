%{
#include <ProceduralIcoSphereGenerator.h>
%}

%template(IcoSphereMeshGenerator) Procedural::MeshGenerator<Procedural::IcoSphereGenerator>;

%include ProceduralIcoSphereGenerator.h

%{
%}


