
$LOAD_PATH.push(File.dirname(File.expand_path(__FILE__)) + "../../lib")

require "Ogre"
require "OIS"
require "OgreBites"
require "OgreConfig"
require_relative "UiListener"
require_relative "CameraMover"
require_relative "SinbadCharacter"

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
    initRoot()
    initResources()
    initManagers()
    initListeners()
    initCamera()

    # load "General" group resources into ResourceGroupManager.
    @trayMgr.showLoadingBar(1, 0)
    Ogre::ResourceGroupManager::getSingleton().initialiseResourceGroup("General")
    @trayMgr.hideLoadingBar()
    Ogre::TextureManager::getSingleton().setDefaultNumMipmaps(5)

    @trayMgr.showFrameStats(OgreBites::TL_BOTTOMLEFT)
    @trayMgr.showLogo(OgreBites::TL_BOTTOMRIGHT)
    @trayMgr.hideCursor()

    setupContent()

    @root.startRendering()
  end

  def initRoot()
    @root = Ogre::Root.new("")
    loadPlugins()

    return false unless @root.showConfigDialog()
    @window = @root.initialise(true, "Sinbad")
    @root.addFrameListener(self)
  end

  def loadPlugins()
    cfg = Ogre::ConfigFile.new
    cfg.load("#{$filePath}/plugins.cfg")

    pluginDir = cfg.getSetting("PluginFolder")
    pluginDir += "/" if (pluginDir.length > 0) && (pluginDir[-1] != '/') 

    cfg.each_Settings {|secName, keyName, valueName|
      fullPath = pluginDir + valueName
      fullPath.sub!("<SystemPluginFolder>", OgreConfig::getPluginFolder)
      @root.loadPlugin(fullPath) if (keyName == "Plugin")
    }
  end

  def initResources()
    # Load resource paths from config file
    cfg = Ogre::ConfigFile.new
    cfg.load("#{$filePath}/resources.cfg")

    resourceDir = cfg.getSetting("ResourceFolder")
    resourceDir += "/" if (resourceDir.length > 0) && (resourceDir[-1] != '/')

    cfg.each_Settings {|secName, keyName, valueName|
      next if (keyName == "ResourceFolder")

      fullPath = resourceDir + valueName
      fullPath.sub!("<SystemResourceFolder>", OgreConfig::getResourceFolder)
      Ogre::ResourceGroupManager::getSingleton().addResourceLocation(fullPath, 
                                                                     keyName, 
                                                                     secName)
    }
  end

  def initManagers()
    # initialize InputManager
    windowHnd = Ogre::Intp.new
    @window.getCustomAttribute("WINDOW", windowHnd)
    windowHndStr = sprintf("%d", windowHnd.value())
    pl = OIS::ParamList.new
    pl["WINDOW"] = windowHndStr
    @inputManager = OIS::InputManager::createInputSystem(pl)
    @keyboard = @inputManager.createInputObject(OIS::OISKeyboard, true).toKeyboard()
    @mouse = @inputManager.createInputObject(OIS::OISMouse, true).toMouse()

    # initialize trayManager
    Ogre::ResourceGroupManager::getSingleton().initialiseResourceGroup("Essential")
    @trayMgr = OgreBites::SdkTrayManager.new("Base", @window, @mouse);
    ms = @mouse.getMouseState()
    ms.width = @window.getWidth()
    ms.height = @window.getHeight()

    # initialize sceneMgr
    @sceneMgr = @root.createSceneManager(Ogre::ST_GENERIC)
    @sceneMgr.setShadowTechnique(Ogre::SHADOWTYPE_STENCIL_ADDITIVE)

  end

  def initListeners()
    @keyListener = KeyListener.new(self)
    @keyboard.setEventCallback(@keyListener)

    @mouseListener = MouseListener.new(self)
    @mouse.setEventCallback(@mouseListener)

    @trayListener = TrayListener.new(self)
    @trayMgr.setListener(@trayListener)
  end

  def initCamera()
    # initialize camera
    @camera = @sceneMgr.createCamera("FixCamera")

    # Create one viewport, entire window
    @vp = @window.addViewport(@camera);
    @vp.setBackgroundColour(Ogre::ColourValue.new(0, 0, 0))
    # Alter the camera aspect ratio to match the viewport
    @camera.setAspectRatio(Float(@vp.getActualWidth()) / Float(@vp.getActualHeight()))
  end

  def setupContent()
    # set background and some fog
    @vp.setBackgroundColour(Ogre::ColourValue.new(1.0, 1.0, 0.8))
    @sceneMgr.setFog(Ogre::FOG_LINEAR, Ogre::ColourValue.new(1.0, 1.0, 0.8), 0, 15, 100)

    # set shadow properties
    @sceneMgr.setShadowTechnique(Ogre::SHADOWTYPE_TEXTURE_MODULATIVE)
    @sceneMgr.setShadowColour(Ogre::ColourValue.new(0.5, 0.5, 0.5))
    @sceneMgr.setShadowTextureSize(1024)
    @sceneMgr.setShadowTextureCount(1)

    # use a small amount of ambient lighting
    @sceneMgr.setAmbientLight(Ogre::ColourValue.new(0.3, 0.3, 0.3))

    # add a bright light above the scene
    @light = @sceneMgr.createLight()
    @light.setType(Ogre::Light::LT_POINT)
    @light.setPosition(-10, 40, 20)
    @light.setSpecularColour(Ogre::ColourValue.White)

    # create a floor mesh resource
    Ogre::MeshManager::getSingleton().createPlane("floor", 
                                                  Ogre::ResourceGroupManager.DEFAULT_RESOURCE_GROUP_NAME,
                                                  Ogre::Plane.new(Ogre::Vector3.UNIT_Y, 0), 
                                                  100, 100, 10, 10, true, 1, 10, 10, 
                                                  Ogre::Vector3.UNIT_Z)

    # create a floor entity, give it a material, and place it at the origin
    @floor = @sceneMgr.createEntity("Floor", "floor")
    @floor.setMaterialName("Examples/Rockwall")
    @floor.setCastShadows(false)
    @sceneMgr.getRootSceneNode().attachObject(@floor)

    @cameraMover = CameraMover.new(@camera)
    @cameraMover.setPosition(Ogre::Vector3.new(10, 10, 10))
    @cameraMover.lookAt(Ogre::Vector3.new(0, 0, 0))

    @char = SinbadCharacter.new(@sceneMgr, @cameraMover)

    items = []
    items.push("Help")
    @help = @trayMgr.createParamsPanel(OgreBites::TL_TOPLEFT, "HelpMessage", 100, items)
    @help.setParamValue(Ogre::UTFString.new("Help"), Ogre::UTFString.new("H / F1"))
  end

  def frameRenderingQueued(evt)
    @keyboard.capture()
    @mouse.capture()
    @trayMgr.frameRenderingQueued(evt)

    @char.addTime(evt.timeSinceLastFrame)
    @cameraMover.update(evt.timeSinceLastFrame)

    return !@quit
  end

  def keyPressed(keyEvent)
    @char.injectKeyDown(keyEvent)

    case keyEvent.key 
    when OIS::KC_ESCAPE
      @quit =true
    when OIS::KC_H, OIS::KC_F1
      if (!@trayMgr.isDialogVisible() && @Info["Help"] != "") 
        @trayMgr.showOkDialog(Ogre::UTFString.new("Help"), Ogre::UTFString.new(@Info["Help"]))
      else 
        @trayMgr.closeDialog()
      end
    end

    return true
  end
  
  def keyReleased(keyEvent)
    @char.injectKeyUp(keyEvent)
    return true
  end
  
  def mouseMoved(mouseEvent)
    return true if @trayMgr.injectMouseMove(mouseEvent)
    @cameraMover.mouseMoved(mouseEvent)
    return true
  end

  def mousePressed(mouseEvent, mouseButtonID)
    return true if @trayMgr.injectMouseDown(mouseEvent, mouseButtonID)
    @cameraMover.mousePressed(mouseEvent, mouseButtonID)
    @char.injectMouseDown(mouseEvent, mouseButtonID)
    return true
  end

  def mouseReleased(mouseEvent, mouseButtonID)
    return true if @trayMgr.injectMouseUp(mouseEvent, mouseButtonID)
    @cameraMover.mouseReleased(mouseEvent, mouseButtonID)
    return true
  end
end

sinbad = Sinbad.new
sinbad.run
