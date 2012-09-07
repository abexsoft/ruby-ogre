class CameraMover
  CS_FREELOOK = 0
  CS_ORBIT = 1
  CS_MANUAL = 2
  CS_TPS = 3

  CAM_HEIGHT = 5.0

  attr_accessor :height
  attr_accessor :cameraPivot
  attr_accessor :camera

  def initialize(cam)
    @camera = cam
    @camera.setPosition(0, 0, 0)
    @camera.setNearClipDistance(0.1)

    @style = CS_FREELOOK

    # CS_FREELOOK, CS_ORBIT, CS_MANUAL
    @sdkCameraMan = OgreBites::SdkCameraMan.new(@camera)
    @evtFrame = Ogre::FrameEvent.new

    # CS_TPS
    @height = CAM_HEIGHT
    @cameraPivot = cam.getSceneManager().getRootSceneNode().createChildSceneNode()
    @cameraGoal = @cameraPivot.createChildSceneNode(Ogre::Vector3.new(0, 0, 5))

    @cameraPivot.setFixedYawAxis(true)
    @cameraGoal.setFixedYawAxis(true)

    @pivotPitch = 0

  end

  def setStyle(style)
    @style = style
    case @style
    when CS_FREELOOK
      @sdkCameraMan.setStyle(OgreBites::CS_FREELOOK)
    when CS_ORBIT
      @sdkCameraMan.setStyle(OgreBites::CS_ORBIT)
    else  # CS_MANUAL, CS_TPS
      @sdkCameraMan.setStyle(OgreBites::CS_MANUAL)
    end
  end

  def setTarget(target)
    @target = target
    if @style == CS_TPS
      @camera.setAutoTracking(false)
      @camera.moveRelative(Ogre::Vector3.new(0, 0, 0))
      updateCamera(1.0)
    else
      @sdkCameraMan.setTarget(target)
    end
  end

  def setPosition(pos)
    @camera.setPosition(pos) if @style == CS_FREELOOK
  end

  def lookAt(pos)
    @camera.lookAt(pos) if @style == CS_FREELOOK
  end

  def setYawPitchDist(yaw, pitch, dist)
    @sdkCameraMan.setYawPitchDist(yaw, pitch, dist) if @style == CS_ORBIT
  end

  def moveForward(bl)
    evt = OIS::KeyEvent.new(nil, OIS::KC_W, 0)
    if bl
      @sdkCameraMan.injectKeyDown(evt)
    else
      @sdkCameraMan.injectKeyUp(evt)
    end
  end

  def moveBackward(bl)
    evt = OIS::KeyEvent.new(nil, OIS::KC_S, 0)
    if bl
      @sdkCameraMan.injectKeyDown(evt)
    else
      @sdkCameraMan.injectKeyUp(evt)
    end
  end

  def moveLeft(bl)
    evt = OIS::KeyEvent.new(nil, OIS::KC_A, 0)
    if bl
      @sdkCameraMan.injectKeyDown(evt)
    else
      @sdkCameraMan.injectKeyUp(evt)
    end
  end

  def moveRight(bl)
    evt = OIS::KeyEvent.new(nil, OIS::KC_D, 0)
    if bl
      @sdkCameraMan.injectKeyDown(evt)
    else
      @sdkCameraMan.injectKeyUp(evt)
    end
  end


  def update(delta)
    if (@style == CS_TPS)
      updateCamera(delta)
    else
      @evtFrame.timeSinceLastFrame = delta
      @sdkCameraMan.frameRenderingQueued(@evtFrame)
    end
  end

  #
  # This method moves this camera position to the goal position smoothly.
  # In general, should be called in the frameRenderingQueued handler.
  #
  def updateCamera(deltaTime)
    # place the camera pivot roughly at the character's shoulder
    @cameraPivot.setPosition(@target.getPosition() + Ogre::Vector3.UNIT_Y * @height)
    # move the camera smoothly to the goal
    goalOffset = @cameraGoal._getDerivedPosition() - @camera.getPosition()
    @camera.move(goalOffset * deltaTime * 9.0)
    # always look at the pivot
    @camera.lookAt(@cameraPivot._getDerivedPosition())
  end

  def mouseMoved(evt)
    if @style == CS_TPS
      updateCameraGoal(-0.05 * evt.state.X.rel, 
                       -0.05 * evt.state.Y.rel, 
                       -0.0005 * evt.state.Z.rel)
    else
      @sdkCameraMan.injectMouseMove(evt)      
    end    
    return true
  end

  #
  # This method updates the goal position, which this camera should be placed finally.
  # In general, should be called when the mouse is moved.
  # *deltaYaw*::_float_, degree value.
  # *deltaPitch*::_float_, degree value.
  # *deltaZoom*::_float_, zoom 
  #
  def updateCameraGoal(deltaYaw, deltaPitch, deltaZoom)
    @cameraPivot.yaw(Ogre::Radian.new(Ogre::Degree.new(deltaYaw)), Ogre::Node::TS_WORLD);
    @cameraPivot.pitch(Ogre::Radian.new(Ogre::Degree.new(deltaPitch)), Ogre::Node::TS_LOCAL)
=begin
    # bound the pitch
    if (!(@pivotPitch + deltaPitch > 25 && deltaPitch > 0) &&
        !(@pivotPitch + deltaPitch < -60 && deltaPitch < 0))

      @cameraPivot.pitch(Ogre::Degree.new(deltaPitch).valueRadians, Ogre::Node::TS_LOCAL)
      @pivotPitch += deltaPitch;
    end
=end
    dist = @cameraGoal._getDerivedPosition().distance(@cameraPivot._getDerivedPosition())
    distChange = deltaZoom * dist;

#    puts "dist: #{dist}:#{distChange}"

    # bound the zoom
    if (!(dist + distChange < 8 && distChange < 0) &&
        !(dist + distChange > 25 && distChange > 0))

      @cameraGoal.translate(Ogre::Vector3.new(0, 0, distChange), Ogre::Node::TS_LOCAL)
    end
  end

  def mousePressed(mouseEvent, mouseButtonID)
    @sdkCameraMan.injectMouseDown(mouseEvent, mouseButtonID) if @style == CS_ORBIT
    return true
  end

  def mouseReleased(mouseEvent, mouseButtonID)
    @sdkCameraMan.injectMouseUp(mouseEvent, mouseButtonID) if @style == CS_ORBIT
    return true
  end
  
end
