%{
#include <OISPrereqs.h>
%}

%rename(OisVector3) OIS::Vector3;


%template(PairStrings)     std::pair<std::string, std::string>;
%template(MapStrings) std::map<std::string, std::string>;
//%template(OISMultiMapStr) std::multimap<std::string, std::string>;
%template(ParamList)  std::multimap<std::string, std::string>;

//%typemap(ParamList)  std::multimap<std::string, std::string>;
//%nestedworkaround OIS::ParamList;


%include OISPrereqs.h



