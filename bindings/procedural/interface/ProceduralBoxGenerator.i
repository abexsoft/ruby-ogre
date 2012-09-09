%{
#include <ProceduralBoxGenerator.h>
%}

%template(BoxMeshGenerator) Procedural::MeshGenerator<Procedural::BoxGenerator>;

%include ProceduralBoxGenerator.h

%{
%}


