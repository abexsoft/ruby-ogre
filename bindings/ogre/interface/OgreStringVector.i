%{
#include <OgreStringVector.h>

%}

// Give up =)

//%template(GeneralAlloc)    Ogre::CategorisedAllocPolicy<Ogre::MEMCATEGORY_GENERAL >;
//%template(StdAllocString)  Ogre::STLAllocator<Ogre::String, Ogre::GeneralAllocPolicy>;
//%template(StdAllocString)  Ogre::STLAllocator<Ogre::String, Ogre::CategorisedAllocPolicy<Ogre::MEMCATEGORY_GENERAL > >;
//%template(OgreSTLAlloc) Ogre::STLAllocator<std::basic_string<char>, Ogre::CategorisedAllocPolicy<(Ogre::MemoryCategory)0u> >;
//%template(STLAllocBaseString) Ogre::STLAllocatorBase<std::basic_string<char> >;
//%template(StringVector) Ogre::vector<Ogre::String, Ogre::STLAllocator<Ogre::String, Ogre::GeneralAllocPolicy> >;
//%template(StdStringVector) std::vector<Ogre::String, Ogre::STLAllocator<Ogre::String, Ogre::STLAllocator<Ogre::String, Ogre::CategorisedAllocPolicy<Ogre::MEMCATEGORY_GENERAL > > > >;
//%template(StdStringVector)  std::vector<std::basic_string<char>, Ogre::STLAllocator<std::basic_string<char>, Ogre::CategorisedAllocPolicy<(Ogre::MemoryCategory)0u> > >;
//%template(StringVector)     std::vector< std::string,std::allocator< std::string > >;
//%template(VectorString) Ogre::vector<Ogre::String>;
//%template(StringVector) Ogre::vector<Ogre::String, Ogre::STLAllocator<Ogre::String, Ogre::GeneralAllocPolicy > >;


%include OgreStringVector.h

