class SinbadCharacter
  NUM_ANIMS = 13           # number of animations the character has
  CHAR_HEIGHT = 5          # height of character's center of mass above ground
  CAM_HEIGHT = 2           # height of camera above character's center of mass
  RUN_SPEED = 17           # character running speed in units per second
  TURN_SPEED = 500.0       # character turning in degrees per second
  ANIM_FADE_SPEED = 7.5    # animation crossfade speed in % of full weight per second
  JUMP_ACCEL = 30.0        # character jump acceleration in upward units per squared second
  GRAVITY = 90.0           # gravity in downward units per squared second

  ANIM_IDLE_BASE        = 0
  ANIM_IDLE_TOP         = 1
  ANIM_RUN_BASE         = 2
  ANIM_RUN_TOP          = 3
  ANIM_HANDS_CLOSED     = 4
  ANIM_HANDS_RELAXED    = 5
  ANIM_DRAW_SWORDS      = 6
  ANIM_SLICE_VERTICAL   = 7
  ANIM_SLICE_HORIZONTAL = 8
  ANIM_DANCE            = 9
  ANIM_JUMP_START       = 10
  ANIM_JUMP_LOOP        = 11
  ANIM_JUMP_END         = 12
  ANIM_NONE             = 13

  def initialize(sceneMgr, cameraMover)
    setup_body(sceneMgr)
    setup_camera(cameraMover)
    setup_animations()
  end

  def setup_body(sceneMgr)
    # create main model
    @bodyNode = sceneMgr.get_root_scene_node().create_child_scene_node(Ogre::Vector3.UNIT_Y * CHAR_HEIGHT)
    @bodyEnt = sceneMgr.create_entity("SinbadBody", "Sinbad.mesh")
    @bodyNode.attach_object(@bodyEnt)

    # create swords and attach to sheath
    @sword1 = sceneMgr.create_entity("SinbadSword1", "Sword.mesh")
    @sword2 = sceneMgr.create_entity("SinbadSword2", "Sword.mesh")
    @bodyEnt.attach_object_to_bone("Sheath.L", @sword1)
    @bodyEnt.attach_object_to_bone("Sheath.R", @sword2)

    # create a couple of ribbon trails for the swords, just for fun
    params = {}
    #params = Ogre::NameValuePairList.new
    params["numberOfChains"] = "2"
    params["maxElements"] = "80"
    @swordTrail = Ogre::RibbonTrail::cast(sceneMgr.create_movable_object("RibbonTrail", params))
    @swordTrail.set_material_name("Examples/LightRibbonTrail")
    @swordTrail.set_trail_length(20)
    @swordTrail.set_visible(false)
    sceneMgr.get_root_scene_node().attach_object(@swordTrail)

    2.times.each {|i|
      @swordTrail.set_initial_colour(i, 1, 0.8, 0)
      @swordTrail.set_colour_change(i, 0.75, 1.25, 1.25, 1.25)
      @swordTrail.set_width_change(i, 1)
      @swordTrail.set_initial_width(i, 0.5)
    }

    @keyDirection = Ogre::Vector3.new(0, 0, 0)
    @verticalVelocity = 0
    @timer = 0
  end

  def setup_camera(cameraMover)
    @cameraMover = cameraMover
    cameraMover.set_style(CameraMover::CS_TPS)
    cameraMover.set_target(@bodyNode)
  end

  def setup_animations()
    @anims = []
    @fadingIn = []
    @fadingOut = []
    @baseAnimID = 0
    @topAnimID = 0

    @bodyEnt.get_skeleton().set_blend_mode(Ogre::ANIMBLEND_CUMULATIVE)
    animNames =["IdleBase", "IdleTop", "RunBase", "RunTop", "HandsClosed", "HandsRelaxed", "DrawSwords",
                "SliceVertical", "SliceHorizontal", "Dance", "JumpStart", "JumpLoop", "JumpEnd"]
    animNames.each_with_index {|name, i|
      @anims[i] = @bodyEnt.get_animation_state(name)
      @anims[i].set_loop(true)
      @fadingIn[i] = false
      @fadingOut[i] = false
    }

    # start off in the idle state (top and bottom together)
    set_base_animation(ANIM_IDLE_BASE)
    set_top_animation(ANIM_IDLE_TOP)

    # relax the hands since we're not holding anything
    @anims[ANIM_HANDS_RELAXED].set_enabled(true)

    @swordsDrawn = false
  end

  def set_base_animation(id, reset = false)
    if (@baseAnimID >= 0 && @baseAnimID < NUM_ANIMS)
      # if we have an old animation, fade it out
      @fadingIn[@baseAnimID] = false
      @fadingOut[@baseAnimID] = true
    end

    @baseAnimID = id

    if (id != ANIM_NONE)
      # if we have a new animation, enable it and fade it in
      @anims[id].set_enabled(true)
      @anims[id].set_weight(0)
      @fadingOut[id] = false
      @fadingIn[id] = true
      @anims[id].set_time_position(0) if (reset) 
    end
  end

  def set_top_animation(id, reset = false)
    if (@topAnimID >= 0 && @topAnimID < NUM_ANIMS)
      # if we have an old animation, fade it out
      @fadingIn[@topAnimID] = false
      @fadingOut[@topAnimID] = true
    end

    @topAnimID = id

    if (id != ANIM_NONE)
      # if we have a new animation, enable it and fade it in
      @anims[id].set_enabled(true)
      @anims[id].set_weight(0)
      @fadingOut[id] = false
      @fadingIn[id] = true
      @anims[id].set_time_position(0) if (reset) 
    end
  end

  def update_body(deltaTime)
    @goalDirection = Ogre::Vector3.new(0, 0, 0) # we will calculate this

    if (!@keyDirection.is_zero_length && @baseAnimID != ANIM_DANCE)

      # calculate actually goal direction in world based on player's key directions
      @goalDirection += @cameraMover.camera.get_orientation().z_axis() * @keyDirection.z
      @goalDirection += @cameraMover.camera.get_orientation().x_axis() * @keyDirection.x
      @goalDirection.y = 0
      @goalDirection.normalise()

      zDirection = @cameraMover.camera.get_orientation().z_axis()

      toGoal = @bodyNode.get_orientation().z_axis().get_rotation_to(@goalDirection)

      # calculate how much the character has to turn to face goal direction
      yawToGoal = toGoal.get_yaw().value_degrees()
      # this is how much the character CAN turn this frame
      yawAtSpeed = yawToGoal / yawToGoal.abs * deltaTime * TURN_SPEED
      # reduce "turnability" if we're in midair
      yawAtSpeed *= 0.2 if (@baseAnimID == ANIM_JUMP_LOOP)

      # turn as much as we can, but not more than we need to
      if (yawToGoal < 0) 
        yawToGoal = [0, [yawToGoal, yawAtSpeed].max].min
      elsif (yawToGoal > 0) 
        yawToGoal = [0, [yawToGoal, yawAtSpeed].min].max
      end
                        
      @bodyNode.yaw(Ogre::Radian.new(Ogre::Degree.new(yawToGoal).value_radians()))

      # move in current body direction (not the goal direction)
      @bodyNode.translate(0, 0, deltaTime * RUN_SPEED * @anims[@baseAnimID].get_weight(),
                          Ogre::Node::TS_LOCAL)
    end

    if (@baseAnimID == ANIM_JUMP_LOOP)
      # if we're jumping, add a vertical offset too, and apply gravity
      @bodyNode.translate(0, @verticalVelocity * deltaTime, 0, Ogre::Node::TS_LOCAL)
      @verticalVelocity -= GRAVITY * deltaTime;
                        
      pos = @bodyNode.get_position()
      if (pos.y <= CHAR_HEIGHT)
        # if we've hit the ground, change to landing state
        pos.y = CHAR_HEIGHT
        @bodyNode.set_position(pos)
        set_base_animation(ANIM_JUMP_END, true)
        @timer = 0
      end
    end
  end

  def update_animations(deltaTime)
    baseAnimSpeed = 1
    topAnimSpeed = 1

    @timer += deltaTime

    if (@topAnimID == ANIM_DRAW_SWORDS)
      # flip the draw swords animation if we need to put it back
      topAnimSpeed = @swordsDrawn ? -1 : 1

      # half-way through the animation is when the hand grasps the handles...
      if (@timer >= @anims[@topAnimID].get_length() / 2 &&
          @timer - deltaTime < @anims[@topAnimID].get_length() / 2)
        # so transfer the swords from the sheaths to the hands
        @bodyEnt.detach_all_objects_from_bone()
        @bodyEnt.attach_object_to_bone(@swordsDrawn ? "Sheath.L" : "Handle.L", @sword1)
        @bodyEnt.attach_object_to_bone(@swordsDrawn ? "Sheath.R" : "Handle.R", @sword2)
        # change the hand state to grab or let go
        @anims[ANIM_HANDS_CLOSED].set_enabled(!@swordsDrawn)
        @anims[ANIM_HANDS_RELAXED].set_enabled(@swordsDrawn)

        # toggle sword trails
        if (@swordsDrawn)
          @swordTrail.set_visible(false)
          @swordTrail.remove_node(@sword1.get_parent_node())
          @swordTrail.remove_node(@sword2.get_parent_node())
        else
          @swordTrail.set_visible(true)
          @swordTrail.add_node(@sword1.get_parent_node())
          @swordTrail.add_node(@sword2.get_parent_node())
        end
      end

      if (@timer >= @anims[@topAnimID].get_length())
        # animation is finished, so return to what we were doing before
        if (@baseAnimID == ANIM_IDLE_BASE) 
          set_top_animation(ANIM_IDLE_TOP)
        else
          set_top_animation(ANIM_RUN_TOP)
          @anims[ANIM_RUN_TOP].set_time_position(@anims[ANIM_RUN_BASE].get_time_position())
        end
        @swordsDrawn = !@swordsDrawn
      end

    elsif (@topAnimID == ANIM_SLICE_VERTICAL || @topAnimID == ANIM_SLICE_HORIZONTAL)
      if (@timer >= @anims[@topAnimID].get_length())
        # animation is finished, so return to what we were doing before
        if (@baseAnimID == ANIM_IDLE_BASE) 
          set_top_animation(ANIM_IDLE_TOP)
        else
          set_top_animation(ANIM_RUN_TOP)
          @anims[ANIM_RUN_TOP].set_time_position(@anims[ANIM_RUN_BASE].get_time_position())
        end
      end
      # don't sway hips from side to side when slicing. that's just embarrasing.
      baseAnimSpeed = 0 if (@baseAnimID == ANIM_IDLE_BASE) 

    elsif (@baseAnimID == ANIM_JUMP_START)
      if (@timer >= @anims[@baseAnimID].get_length())
        # takeoff animation finished, so time to leave the ground!
        set_base_animation(ANIM_JUMP_LOOP, true)
        # apply a jump acceleration to the character
        @verticalVelocity = JUMP_ACCEL
      end
    elsif (@baseAnimID == ANIM_JUMP_END)
      if (@timer >= @anims[@baseAnimID].get_length())
        # safely landed, so go back to running or idling
        if (@keyDirection.is_zero_length)
          set_base_animation(ANIM_IDLE_BASE)
          set_top_animation(ANIM_IDLE_TOP)
        else
          set_base_animation(ANIM_RUN_BASE, true)
          set_top_animation(ANIM_RUN_TOP, true)
        end
      end
    end
    # increment the current base and top animation times
    @anims[@baseAnimID].add_time(deltaTime * baseAnimSpeed) if (@baseAnimID != ANIM_NONE) 
    @anims[@topAnimID].add_time(deltaTime * topAnimSpeed) if (@topAnimID != ANIM_NONE) 
    
    # apply smooth transitioning between our animations
    fade_animations(deltaTime)
  end

  def clamp(value, min, max)
    return max if (value > max)
    return min if (value < min)
    return value
  end
  
  def fade_animations(deltaTime)
    NUM_ANIMS.times {|i|
      if (@fadingIn[i])
        # slowly fade this animation in until it has full weight
        newWeight = @anims[i].get_weight() + deltaTime * ANIM_FADE_SPEED
        @anims[i].set_weight(clamp(newWeight, 0, 1))
        @fadingIn[i] = false if (newWeight >= 1) 

      elsif (@fadingOut[i])
        # slowly fade this animation out until it has no weight, and then disable it
        newWeight = @anims[i].get_weight() - deltaTime * ANIM_FADE_SPEED
        @anims[i].set_weight(clamp(newWeight, 0, 1))
        if (newWeight <= 0)
          @anims[i].set_enabled(false)
          @fadingOut[i] = false
        end
      end
    }
  end

  def add_time(delta)
    update_body(delta)
    update_animations(delta)
  end

  def inject_key_down(evt)
    if (evt.key == Ois::KC_Q && (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP))
      # take swords out (or put them back, since it's the same animation but reversed)
      set_top_animation(ANIM_DRAW_SWORDS, true)
      @timer = 0
    elsif (evt.key == Ois::KC_E && !@swordsDrawn)
      if (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP)
        # start dancing
        set_base_animation(ANIM_DANCE, true)
        set_top_animation(ANIM_NONE)
        # disable hand animation because the dance controls hands
        @anims[ANIM_HANDS_RELAXED].set_enabled(false)
      elsif (@baseAnimID == ANIM_DANCE)
        # stop dancing
        set_base_animation(ANIM_IDLE_BASE)
        set_top_animation(ANIM_IDLE_TOP)
        # re-enable hand animation
        @anims[ANIM_HANDS_RELAXED].set_enabled(true)
      end
    # keep track of the player's intended direction
    elsif (evt.key == Ois::KC_W) 
      @keyDirection.z = -1
    elsif (evt.key == Ois::KC_A) 
      @keyDirection.x = -1
    elsif (evt.key == Ois::KC_S) 
      @keyDirection.z = 1
    elsif (evt.key == Ois::KC_D) 
      @keyDirection.x = 1
    elsif (evt.key == Ois::KC_SPACE && (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP))
      # jump if on ground
      set_base_animation(ANIM_JUMP_START, true)
      set_top_animation(ANIM_NONE)
      @timer = 0
    end

    if (!@keyDirection.is_zero_length() && @baseAnimID == ANIM_IDLE_BASE)
      # start running if not already moving and the player wants to move
      set_base_animation(ANIM_RUN_BASE, true)
      set_top_animation(ANIM_RUN_TOP, true) if (@topAnimID == ANIM_IDLE_TOP) 
    end
    
  end

  def inject_key_up(evt)
    # keep track of the player's intended direction
    if (evt.key == Ois::KC_W && @keyDirection.z == -1) 
      @keyDirection.z = 0 
    elsif (evt.key == Ois::KC_A && @keyDirection.x == -1) 
      @keyDirection.x = 0
    elsif (evt.key == Ois::KC_S && @keyDirection.z == 1) 
      @keyDirection.z = 0
    elsif (evt.key == Ois::KC_D && @keyDirection.x == 1) 
      @keyDirection.x = 0
    end

    if (@keyDirection.is_zero_length() && @baseAnimID == ANIM_RUN_BASE)
      # stop running if already moving and the player doesn't want to move
      set_base_animation(ANIM_IDLE_BASE)
      set_top_animation(ANIM_IDLE_TOP) if (@topAnimID == ANIM_RUN_TOP) 
    end
  end

  def inject_mouse_down(evt, id)
    if (@swordsDrawn && (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP))
      # if swords are out, and character's not doing something weird, then SLICE!
      if (id == Ois::MB_Left) 
        set_top_animation(ANIM_SLICE_VERTICAL, true) 
      elsif (id == Ois::MB_Right) 
        set_top_animation(ANIM_SLICE_HORIZONTAL, true)
      end
      @timer = 0
    end
  end

end
