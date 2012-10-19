
$LOAD_PATH.push(File.dirname(File.expand_path(__FILE__)) + "/../../lib")

require "ogre"
require "ois"
require "ogrebites"
require "ogre_config"
require_relative "ui_listener"
require_relative "camera_mover"
require_relative "sinbad_character"

class Sinbad < Ogre::FrameListener
  def initialize()
    super  # initialize Ogre::FrameListener.
    @root = nil
    @window = nil
    @camera = nil
    @sceneMgr = nil
    @inputManager = nil
    @mouse = nil
    @keyboard = nil
    @trayMgr = nil

    @quit = false

    @Info = {}
    @Info["Help"] = 
      "Use the WASD keys to move Sinbad, and the space bar to jump. \n" + 
      " Use mouse to look around and mouse wheel to zoom.\n" + 
      " Press Q to take out or put back Sinbad's swords. With the swords equipped, " + 
      "you can left click to slice vertically or right click to slice horizontally.\n" +
      " When the swords are not equipped, press E to start/stop a silly dance routine."

    $filePath = File.dirname(File.expand_path(__FILE__))
  end

  def run
    return unless init_root()
    init_resources()
    init_managers()
    init_listeners()
    init_camera()

    # load "General" group resources into ResourceGroupManager.
    @trayMgr.show_loading_bar(1, 0)
    Ogre::ResourceGroupManager::get_singleton().initialise_resource_group("General")
    @trayMgr.hide_loading_bar()
    Ogre::TextureManager::get_singleton().set_default_num_mipmaps(5)

    @trayMgr.show_frame_stats(Ogrebites::TL_BOTTOMLEFT)
    @trayMgr.show_logo(Ogrebites::TL_BOTTOMRIGHT)
    @trayMgr.hide_cursor()

    setup_content()

    @root.start_rendering()
  end

  def init_root()
    @root = Ogre::Root.new("")
    load_plugins()

    if @root.show_config_dialog()
      @window = @root.initialise(true, "Sinbad")
      @root.add_frame_listener(self)
      return true
    end

    return false
  end

  def load_plugins()
    cfg = Ogre::ConfigFile.new
    cfg.load("#{$filePath}/plugins.cfg")

    pluginDir = cfg.get_setting("PluginFolder")
    pluginDir += "/" if (pluginDir.length > 0) && (pluginDir[-1] != '/') 

    cfg.each_settings {|secName, keyName, valueName|
      fullPath = pluginDir + valueName
      fullPath.sub!("<SystemPluginFolder>", OgreConfig::get_plugin_folder)
      @root.load_plugin(fullPath) if (keyName == "Plugin")
    }
  end

  def init_resources()
    # Load resource paths from config file
    cfg = Ogre::ConfigFile.new
    cfg.load("#{$filePath}/resources.cfg")

    resourceDir = cfg.get_setting("ResourceFolder")
    resourceDir += "/" if (resourceDir.length > 0) && (resourceDir[-1] != '/')

    cfg.each_settings {|secName, keyName, valueName|
      next if (keyName == "ResourceFolder")

      fullPath = resourceDir + valueName
      fullPath.sub!("<SystemResourceFolder>", OgreConfig::get_resource_folder)
      Ogre::ResourceGroupManager::get_singleton().add_resource_location(fullPath, 
                                                                        keyName, 
                                                                        secName)
    }
  end

  def init_managers()
    # initialize InputManager
    windowHnd = Ogre::Intp.new
    @window.get_custom_attribute("WINDOW", windowHnd)
    windowHndStr = sprintf("%d", windowHnd.value())
    pl = Ois::ParamList.new
    pl["WINDOW"] = windowHndStr
    @inputManager = Ois::InputManager::create_input_system(pl)
    @keyboard = @inputManager.create_input_object(Ois::OISKeyboard, true).to_keyboard()
    @mouse = @inputManager.create_input_object(Ois::OISMouse, true).to_mouse()

    # initialize trayManager
    Ogre::ResourceGroupManager::get_singleton().initialise_resource_group("Essential")
    @trayMgr = Ogrebites::SdkTrayManager.new("Base", @window, @mouse);
    ms = @mouse.get_mouse_state()
    ms.width = @window.get_width()
    ms.height = @window.get_height()

    # initialize sceneMgr
    @sceneMgr = @root.create_scene_manager(Ogre::ST_GENERIC)
    @sceneMgr.set_shadow_technique(Ogre::SHADOWTYPE_STENCIL_ADDITIVE)

  end

  def init_listeners()
    @keyListener = KeyListener.new(self)
    @keyboard.set_event_callback(@keyListener)

    @mouseListener = MouseListener.new(self)
    @mouse.set_event_callback(@mouseListener)

    @trayListener = TrayListener.new(self)
    @trayMgr.set_listener(@trayListener)
  end

  def init_camera()
    # initialize camera
    @camera = @sceneMgr.create_camera("FixCamera")

    # Create one viewport, entire window
    @vp = @window.add_viewport(@camera);
    @vp.set_background_colour(Ogre::ColourValue.new(0, 0, 0))
    # Alter the camera aspect ratio to match the viewport
    @camera.set_aspect_ratio(Float(@vp.get_actual_width()) / Float(@vp.get_actual_height()))
  end

  def setup_content()
    # set background and some fog
    @vp.set_background_colour(Ogre::ColourValue.new(1.0, 1.0, 0.8))
    @sceneMgr.set_fog(Ogre::FOG_LINEAR, Ogre::ColourValue.new(1.0, 1.0, 0.8), 0, 15, 100)

    # set shadow properties
    @sceneMgr.set_shadow_technique(Ogre::SHADOWTYPE_TEXTURE_MODULATIVE)
    @sceneMgr.set_shadow_colour(Ogre::ColourValue.new(0.5, 0.5, 0.5))
    @sceneMgr.set_shadow_texture_size(1024)
    @sceneMgr.set_shadow_texture_count(1)

    # use a small amount of ambient lighting
    @sceneMgr.set_ambient_light(Ogre::ColourValue.new(0.3, 0.3, 0.3))

    # add a bright light above the scene
    @light = @sceneMgr.create_light()
    @light.set_type(Ogre::Light::LT_POINT)
    @light.set_position(-10, 40, 20)
    @light.set_specular_colour(Ogre::ColourValue.White)

    # create a floor mesh resource
    Ogre::MeshManager::get_singleton().create_plane("floor", 
                                                    Ogre::ResourceGroupManager.DEFAULT_RESOURCE_GROUP_NAME,
                                                    Ogre::Plane.new(Ogre::Vector3.UNIT_Y, 0), 
                                                    100, 100, 10, 10, true, 1, 10, 10, 
                                                    Ogre::Vector3.UNIT_Z)

    # create a floor entity, give it a material, and place it at the origin
    @floor = @sceneMgr.create_entity("Floor", "floor")
    @floor.set_material_name("Examples/Rockwall")
    @floor.set_cast_shadows(false)
    @sceneMgr.get_root_scene_node().attach_object(@floor)

    @cameraMover = CameraMover.new(@camera)
    @cameraMover.set_position(Ogre::Vector3.new(10, 10, 10))
    @cameraMover.look_at(Ogre::Vector3.new(0, 0, 0))

    @char = SinbadCharacter.new(@sceneMgr, @cameraMover)

    items = []
    items.push("Help")
    @help = @trayMgr.create_params_panel(Ogrebites::TL_TOPLEFT, "HelpMessage", 100, items)
    @help.set_param_value(Ogre::UTFString.new("Help"), Ogre::UTFString.new("H / F1"))
  end

  def frame_rendering_queued(evt)
    @keyboard.capture()
    @mouse.capture()
    @trayMgr.frame_rendering_queued(evt)

    @char.add_time(evt.timeSinceLastFrame)
    @cameraMover.update(evt.timeSinceLastFrame)

    return !@quit
  end

  def key_pressed(keyEvent)
    @char.inject_key_down(keyEvent)

    case keyEvent.key 
    when Ois::KC_ESCAPE
      @quit =true
    when Ois::KC_H, Ois::KC_F1
      if (!@trayMgr.is_dialog_visible() && @Info["Help"] != "") 
        @trayMgr.show_ok_dialog(Ogre::UTFString.new("Help"), Ogre::UTFString.new(@Info["Help"]))
      else 
        @trayMgr.close_dialog()
      end
    end

    return true
  end
  
  def key_released(keyEvent)
    @char.inject_key_up(keyEvent)
    return true
  end
  
  def mouse_moved(mouseEvent)
    return true if @trayMgr.inject_mouse_move(mouseEvent)
    @cameraMover.mouse_moved(mouseEvent)
    return true
  end

  def mouse_pressed(mouseEvent, mouseButtonID)
    return true if @trayMgr.inject_mouse_down(mouseEvent, mouseButtonID)
    @cameraMover.mouse_pressed(mouseEvent, mouseButtonID)
    @char.inject_mouse_down(mouseEvent, mouseButtonID)
    return true
  end

  def mouse_released(mouseEvent, mouseButtonID)
    return true if @trayMgr.inject_mouse_up(mouseEvent, mouseButtonID)
    @cameraMover.mouse_released(mouseEvent, mouseButtonID)
    return true
  end
end

sinbad = Sinbad.new
sinbad.run
