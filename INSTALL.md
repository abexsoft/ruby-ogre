Using libraries
--------------
* ruby : http://www.ruby-lang.org/
* swig : http://www.swig.org/
* ois : http://wgois.cvs.sourceforge.net/viewvc/wgois/ois/
* ogre3d : http://www.ogre3d.org/
* ogre-procedural: http://code.google.com/p/ogre-procedural/


How to compile all libraries.
--------------
1. compile external libraries.
   
    > $ rake download  
    > $ rake compile  

2. make ruby extension libraries.

    > $ rake copylibs   
    > $ rake build

3. install ruby extension libraries and so on.

    > $ rake package  
    > $ sudo gem install pkg/ruby-ogrelet-\<version>-\<arch>.gem  
