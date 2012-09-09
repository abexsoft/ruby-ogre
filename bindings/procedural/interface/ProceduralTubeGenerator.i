%{
#include <ProceduralTubeGenerator.h>
%}

%template(TubeMeshGenerator) Procedural::MeshGenerator<Procedural::TubeGenerator>;

%include ProceduralTubeGenerator.h

%{
%}


