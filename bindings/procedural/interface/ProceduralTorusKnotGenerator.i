%{
#include <ProceduralTorusKnotGenerator.h>
%}

%template(TorusKnotMeshGenerator) Procedural::MeshGenerator<Procedural::TorusKnotGenerator>;

%include ProceduralTorusKnotGenerator.h

%{
%}


