class OgreConfig
  def self.getTopDir
    File.dirname(File.dirname(File.expand_path(__FILE__)))
  end

  def self.getLdLibraryPath
    "#{getTopDir()}/deps/lib"
  end

  def self.getDepsLibPath
    "#{getTopDir()}/deps/lib"
  end

  def self.getDepsIncPath
    "#{getTopDir()}/deps/include"
  end

  def self.getIncFlags
    "-I#{getTopDir()}/deps/include/OGRE/ " +
    "-I#{getTopDir()}/deps/include/OGRE/GLX/ " +
    "-I#{getTopDir()}/deps/include/OGRE/Paging/ " +
    "-I#{getTopDir()}/deps/include/OGRE/RTShaderSystem/ " +
    "-I#{getTopDir()}/deps/include/OGRE/Terrain "
  end

  def self.getLib
    File.dirname(File.expand_path(__FILE__))
  end

  def self.getPluginFolder
    "#{getTopDir()}/deps/lib/OGRE"
  end

  def self.getResourceFolder
    "#{getTopDir()}/deps/share/OGRE/media/"
  end
end
