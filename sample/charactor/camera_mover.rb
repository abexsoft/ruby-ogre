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
    @camera.set_position(0, 0, 0)
    @camera.set_near_clip_distance(0.1)

    @style = CS_FREELOOK

    # CS_FREELOOK, CS_ORBIT, CS_MANUAL
    @sdkCameraMan = Ogrebites::SdkCameraMan.new(@camera)
    @evtFrame = Ogre::FrameEvent.new

    # CS_TPS
    @height = CAM_HEIGHT
    @cameraPivot = cam.get_scene_manager().get_root_scene_node().create_child_scene_node()
    @cameraGoal = @cameraPivot.create_child_scene_node(Ogre::Vector3.new(0, 0, 5))

    @cameraPivot.set_fixed_yaw_axis(true)
    @cameraGoal.set_fixed_yaw_axis(true)

    @pivotPitch = 0

  end

  def set_style(style)
    @style = style
    case @style
    when CS_FREELOOK
      @sdkCameraMan.set_style(Ogrebites::CS_FREELOOK)
    when CS_ORBIT
      @sdkCameraMan.set_style(Ogrebites::CS_ORBIT)
    else  # CS_MANUAL, CS_TPS
      @sdkCameraMan.set_style(Ogrebites::CS_MANUAL)
    end
  end

  def set_target(target)
    @target = target
    if @style == CS_TPS
      @camera.set_auto_tracking(false)
      @camera.move_relative(Ogre::Vector3.new(0, 0, 0))
      update_camera(1.0)
    else
      @sdkCameraMan.set_target(target)
    end
  end

  def set_position(pos)
    @camera.set_position(pos) if @style == CS_FREELOOK
  end

  def look_at(pos)
    @camera.look_at(pos) if @style == CS_FREELOOK
  end

  def set_yaw_pitch_dist(yaw, pitch, dist)
    @sdkCameraMan.set_yaw_pitch_dist(yaw, pitch, dist) if @style == CS_ORBIT
  end

  def move_forward(bl)
    evt = Ois::KeyEvent.new(nil, Ois::KC_W, 0)
    if bl
      @sdkCameraMan.inject_key_down(evt)
    else
      @sdkCameraMan.inject_key_up(evt)
    end
  end

  def move_backward(bl)
    evt = Ois::KeyEvent.new(nil, Ois::KC_S, 0)
    if bl
      @sdkCameraMan.inject_key_down(evt)
    else
      @sdkCameraMan.inject_key_up(evt)
    end
  end

  def move_left(bl)
    evt = Ois::KeyEvent.new(nil, Ois::KC_A, 0)
    if bl
      @sdkCameraMan.inject_key_down(evt)
    else
      @sdkCameraMan.inject_key_up(evt)
    end
  end

  def move_right(bl)
    evt = Ois::KeyEvent.new(nil, Ois::KC_D, 0)
    if bl
      @sdkCameraMan.inject_key_down(evt)
    else
      @sdkCameraMan.inject_key_up(evt)
    end
  end


  def update(delta)
    if (@style == CS_TPS)
      update_camera(delta)
    else
      @evtFrame.timeSinceLastFrame = delta
      @sdkCameraMan.frame_rendering_queued(@evtFrame)
    end
  end

  #
  # This method moves this camera position to the goal position smoothly.
  # In general, should be called in the frameRenderingQueued handler.
  #
  def update_camera(deltaTime)
    # place the camera pivot roughly at the character's shoulder
    @cameraPivot.set_position(@target.get_position() + Ogre::Vector3.UNIT_Y * @height)
    # move the camera smoothly to the goal
    goalOffset = @cameraGoal._get_derived_position() - @camera.get_position()
    @camera.move(goalOffset * deltaTime * 9.0)
    # always look at the pivot
    @camera.look_at(@cameraPivot._get_derived_position())
  end

  def mouse_moved(evt)
    if @style == CS_TPS
      update_camera_goal(-0.05 * evt.state.X.rel, 
                         -0.05 * evt.state.Y.rel, 
                         -0.0005 * evt.state.Z.rel)
    else
      @sdkCameraMan.inject_mouse_move(evt)      
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
  def update_camera_goal(deltaYaw, deltaPitch, deltaZoom)
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
    dist = @cameraGoal._get_derived_position().distance(@cameraPivot._get_derived_position())
    distChange = deltaZoom * dist;

#    puts "dist: #{dist}:#{distChange}"

    # bound the zoom
    if (!(dist + distChange < 8 && distChange < 0) &&
        !(dist + distChange > 25 && distChange > 0))

      @cameraGoal.translate(Ogre::Vector3.new(0, 0, distChange), Ogre::Node::TS_LOCAL)
    end
  end

  def mouse_pressed(mouseEvent, mouseButtonID)
    @sdkCameraMan.inject_mouse_down(mouseEvent, mouseButtonID) if @style == CS_ORBIT
    return true
  end

  def mouse_released(mouseEvent, mouseButtonID)
    @sdkCameraMan.inject_mouse_up(mouseEvent, mouseButtonID) if @style == CS_ORBIT
    return true
  end
  
end
