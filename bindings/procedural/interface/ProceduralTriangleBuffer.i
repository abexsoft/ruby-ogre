%{
#include <ProceduralTriangleBuffer.h>
%}

%nestedworkaround Procedural::TriangleBuffer::Vertex;

%include ProceduralTriangleBuffer.h

%{
	typedef Procedural::TriangleBuffer::Vertex Vertex;
%}


