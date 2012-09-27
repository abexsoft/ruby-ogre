ruby-ogre
=================

Overview
----
Ruby-ogre is a ruby extension library set for Ogre, OIS and OgreProcedural.


How to install
----
This project has a pre-compiled gem.  

     $ sudo gem install pkg/ruby-ogre-<version>-<arch>.gem


Usages
-----
Run a sample application.

     $ /var/lib/gems/<ruby-version>/gems/ruby-ogre-<version>-<arch>/sample/Charactor/sinbad


How to compile
----
see [INSTALL.md](https://github.com/abexsoft/ruby-ogre/blob/master/INSTALL.md)


About APIs
----
This is a wrapper library converted by Swig. Swig is a excellent tool, but it has
several limitations to make complete wrapper interfaces.(ex. not supported nested class.)  
So I list some notes here.

### Basic Conversion
    ** C++ **
    root = new Ogre::Root("")
    root->initialise(true, "Sinbad")

    ** Ruby **
    root = Ogre::Root.new("")
    root.initialise(true, "Sinbad")


### Nested Class

Swig does not support the nested class, so ruby-ogre doesn't support it. 
Luckily, it does not matter so much because the main classes of Ogre are the top level classes.

To be precise, swig has a workaroud for the nested class syntax that expands it
to a top level class. I tried this (ref. bindings/ogre/interface/OgreResourceGroupManager.i),
but I'm sorry it was so boring for me to do for all of the nested classes and definitions.

Please send me (or send a pull request) if you write these swig interface files or have another cool idea =).

### Iterator (crazy template)
  There is another swig problem, template expansion. As same as the nested class problem, swig has
  a workaround but ogre has some complex templates enough to beat me =). Though I tried to fight these
  templates (see, bindings/ogre/interface/OgreConfigFile.i), I could not expand finally.

  Instead, I took a policy to define "each" method on the class with the major iterator.
  (see, bindings/ogre/interface/OgreConfigFile.i::each_Settings). But as same as the nested class problem,
  I do not seem to have the patience enough to apply to all =).

  Please send me (or send a pull request) if you write these swig interface files or have another cool idea, again.

     ** C++ **
     Ogre::ConfigFile cf;
     cf.load("./resources.cfg");
     Ogre::ConfigFile::SectionIterator seci = cf.getSectionIterator();
     Ogre::String secName, typeName, archName;
     while (seci.hasMoreElements())
     {
        secName = seci.peekNextKey();
        Ogre::ConfigFile::SettingsMultiMap *settings = seci.getNext();
        Ogre::ConfigFile::SettingsMultiMap::iterator i;
        for (i = settings->begin(); i != settings->end(); ++i)
        {
            typeName = i->first;
            archName = i->second;
            Ogre::ResourceGroupManager::getSingleton().addResourceLocation(
                archName, typeName, secName);
        }
     }


     ** Ruby **
     cf = Ogre::ConfigFile.new
     cf.load("./resources.cfg")
     cf.each_Settings {|secName, typeName, archName|
       Ogre::ResourceGroupManager::getSingleton().addResourceLocation(
                archName, typeName, secName)
     }

### Scope
  Most ruby objects have a corresponding C++ object pointer. So it will occurs a segmentation fault 
  if you store a root object into a local scope value, like the following example.

    def init
      root = Ogre::Root.new("")
    end


License
----------
Ruby-ogre is licensed under MIT License.

Copyright (C) 2012 abexsoft@gmail.com


