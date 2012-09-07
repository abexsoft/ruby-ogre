class OgreConfig
  def self.getLdLibraryPath
    File.dirname(File.dirname(File.expand_path(__FILE__))) + "/deps/lib"
  end

  def self.getLib
    File.dirname(File.expand_path(__FILE__))
  end

  def self.getPluginFolder
    File.dirname(File.dirname(File.expand_path(__FILE__))) + "/deps/lib/OGRE"
  end

  def self.getResourceFolder
    File.dirname(File.dirname(File.expand_path(__FILE__))) + "/deps/share/OGRE/media/"
  end
end
