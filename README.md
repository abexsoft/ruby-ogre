# ruby-ogre

Ruby-ogre is a ruby binding for Ogre.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-ogre'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-ogre

## Usages

Run a sample application.

    $ /var/lib/gems/<ruby-version>/gems/ruby-ogre-<version>-<arch>/sample/Charactor/sinbad


## How to install from source.

If you want to compile from source, try the following.

    $ git clone git://github.com/abexsoft/ruby-ogre.git 
    $ cd ruby-ogre 
    $ rake download 
    $ rake compile 
    $ rake build 
    $ gem build ruby-ogre.gemspec
    $ gem install ruby-ogre-<version>-<arch>.gem 

## About APIs

This is a wrapper library set converted by Swig. Swig is a excellent tool, but it has
several limitations to make complete wrapper interfaces.(ex. not supported nested class.)  
So I list some notes here.

### Documents for original APIs.
- [OIS](http://wgois.svn.sourceforge.net/viewvc/wgois/ois/trunk/)
- [Ogre3D](http://www.ogre3d.org/docs/api/html/index.html)
- [OgreProcedural](http://docs.ogreprocedural.org/)


### Basic Conversion
    ** C++ **
    root = new Ogre::Root("");
    root->initialise(true, "Sinbad");
    root->addFrameListener(this);

    ** Ruby **
    root = Ogre::Root.new("")
    root.initialise(true, "Sinbad")
    root.add_frame_listener(self)


### Nested Class

Swig does not support the nested class, so ruby-ogre doesn't support it. 
Luckily, it does not matter so much because the main classes of Ogre are the top level classes.

To be precise, swig has a workaroud for the nested class syntax that expands it
to a top level class. I tried this (ref. bindings/ogre/interface/OgreResourceGroupManager.i),
but it is not introduced into all of the nested classes and definitions. I'm grad to receive 
some pull request or another cool idea about this.

### Iterator (complex template)
There is another swig problem, template expansion. As same as the nested class problem, swig has
a workaround but ogre has some complex templates enough to beat me =). Though I tried to fight these
templates (see, bindings/ogre/interface/OgreConfigFile.i), I could not expand finally.

Instead, I took a policy to define "each" method on the class with the major iterator.
(see, bindings/ogre/interface/OgreConfigFile.i::each_Settings). But as same as the nested class problem,
it is not introduced into all. I'm glad if I can receive some pull request or another cool idea about this.

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
     cf.each_settings {|secName, typeName, archName|
       Ogre::ResourceGroupManager::get_singleton().add_resource_location(
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


