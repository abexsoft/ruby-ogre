%{
#include <ProceduralConeGenerator.h>
%}

%template(ConeMeshGenerator) Procedural::MeshGenerator<Procedural::ConeGenerator>;

%include ProceduralConeGenerator.h

%{
%}


