%{
#include <ProceduralTorusGenerator.h>
%}

%template(TorusMeshGenerator) Procedural::MeshGenerator<Procedural::TorusGenerator>;

%include ProceduralTorusGenerator.h

%{
%}


