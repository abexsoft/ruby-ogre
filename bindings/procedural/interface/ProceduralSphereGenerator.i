%{
#include <ProceduralSphereGenerator.h>
%}

%template(SphereMeshGenerator) Procedural::MeshGenerator<Procedural::SphereGenerator>;

%include ProceduralSphereGenerator.h

%{
%}

