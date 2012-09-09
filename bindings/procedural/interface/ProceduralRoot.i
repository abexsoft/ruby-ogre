%{
#include <Ogre.h>
#include <ProceduralRoot.h>
%}

%freefunc Procedural::Root "debug_free_ProcRoot";

%include ProceduralRoot.h

%{

// hmm... someting wrong about GC.	

static void debug_free_ProcRoot(void* ptr) {
	Procedural::Root* obj = (Procedural::Root*) ptr;
	
	std::cout << __PRETTY_FUNCTION__ << std::endl;
	 
//	 delete obj;
 }
%}


