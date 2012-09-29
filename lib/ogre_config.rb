class OgreConfig
  def self.get_top_dir
    File.dirname(File.dirname(File.expand_path(__FILE__)))
  end

  def self.get_ld_library_path
    "#{get_top_dir()}/deps/lib"
  end

  def self.get_deps_lib_path
    "#{get_top_dir()}/deps/lib"
  end

  def self.get_deps_inc_path
    "#{get_top_dir()}/deps/include"
  end

  def self.get_inc_flags
    "-I#{get_top_dir()}/deps/include/OGRE/ " +
    "-I#{get_top_dir()}/deps/include/OGRE/GLX/ " +
    "-I#{get_top_dir()}/deps/include/OGRE/Paging/ " +
    "-I#{get_top_dir()}/deps/include/OGRE/RTShaderSystem/ " +
    "-I#{get_top_dir()}/deps/include/OGRE/Terrain "
  end

  def self.get_lib_path
    File.dirname(File.expand_path(__FILE__))
  end

  def self.get_plugin_folder
    "#{get_top_dir()}/deps/lib/OGRE"
  end

  def self.get_resource_folder
    "#{get_top_dir()}/deps/share/OGRE/media/"
  end
end
