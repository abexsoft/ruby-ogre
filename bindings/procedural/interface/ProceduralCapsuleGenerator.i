%{
#include <ProceduralCapsuleGenerator.h>
%}

%template(CapsuleMeshGenerator) Procedural::MeshGenerator<Procedural::CapsuleGenerator>;

%include ProceduralCapsuleGenerator.h

%{
%}


