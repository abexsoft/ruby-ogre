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
    setupBody(sceneMgr)
    setupCamera(cameraMover)
    setupAnimations()
  end

  def setupBody(sceneMgr)
    # create main model
    @bodyNode = sceneMgr.getRootSceneNode().createChildSceneNode(Ogre::Vector3.UNIT_Y * CHAR_HEIGHT)
    @bodyEnt = sceneMgr.createEntity("SinbadBody", "Sinbad.mesh")
    @bodyNode.attachObject(@bodyEnt)

    # create swords and attach to sheath
    @sword1 = sceneMgr.createEntity("SinbadSword1", "Sword.mesh")
    @sword2 = sceneMgr.createEntity("SinbadSword2", "Sword.mesh")
    @bodyEnt.attachObjectToBone("Sheath.L", @sword1)
    @bodyEnt.attachObjectToBone("Sheath.R", @sword2)

    # create a couple of ribbon trails for the swords, just for fun
    params = {}
    #params = Ogre::NameValuePairList.new
    params["numberOfChains"] = "2"
    params["maxElements"] = "80"
    @swordTrail = Ogre::RibbonTrail::cast(sceneMgr.createMovableObject("RibbonTrail", params))
    @swordTrail.setMaterialName("Examples/LightRibbonTrail")
    @swordTrail.setTrailLength(20)
    @swordTrail.setVisible(false)
    sceneMgr.getRootSceneNode().attachObject(@swordTrail)

    2.times.each {|i|
      @swordTrail.setInitialColour(i, 1, 0.8, 0)
      @swordTrail.setColourChange(i, 0.75, 1.25, 1.25, 1.25)
      @swordTrail.setWidthChange(i, 1)
      @swordTrail.setInitialWidth(i, 0.5)
    }

    @keyDirection = Ogre::Vector3.new(0, 0, 0)
    @verticalVelocity = 0
    @timer = 0
  end

  def setupCamera(cameraMover)
    @cameraMover = cameraMover
    cameraMover.setStyle(CameraMover::CS_TPS)
    cameraMover.setTarget(@bodyNode)
  end

  def setupAnimations()
    @anims = []
    @fadingIn = []
    @fadingOut = []
    @baseAnimID = 0
    @topAnimID = 0

    @bodyEnt.getSkeleton().setBlendMode(Ogre::ANIMBLEND_CUMULATIVE)
    animNames =["IdleBase", "IdleTop", "RunBase", "RunTop", "HandsClosed", "HandsRelaxed", "DrawSwords",
                "SliceVertical", "SliceHorizontal", "Dance", "JumpStart", "JumpLoop", "JumpEnd"]
    animNames.each_with_index {|name, i|
      @anims[i] = @bodyEnt.getAnimationState(name)
      @anims[i].setLoop(true)
      @fadingIn[i] = false
      @fadingOut[i] = false
    }

    # start off in the idle state (top and bottom together)
    setBaseAnimation(ANIM_IDLE_BASE)
    setTopAnimation(ANIM_IDLE_TOP)

    # relax the hands since we're not holding anything
    @anims[ANIM_HANDS_RELAXED].setEnabled(true)

    @swordsDrawn = false
  end

  def setBaseAnimation(id, reset = false)
    if (@baseAnimID >= 0 && @baseAnimID < NUM_ANIMS)
      # if we have an old animation, fade it out
      @fadingIn[@baseAnimID] = false
      @fadingOut[@baseAnimID] = true
    end

    @baseAnimID = id

    if (id != ANIM_NONE)
      # if we have a new animation, enable it and fade it in
      @anims[id].setEnabled(true)
      @anims[id].setWeight(0)
      @fadingOut[id] = false
      @fadingIn[id] = true
      @anims[id].setTimePosition(0) if (reset) 
    end
  end

  def setTopAnimation(id, reset = false)
    if (@topAnimID >= 0 && @topAnimID < NUM_ANIMS)
      # if we have an old animation, fade it out
      @fadingIn[@topAnimID] = false
      @fadingOut[@topAnimID] = true
    end

    @topAnimID = id

    if (id != ANIM_NONE)
      # if we have a new animation, enable it and fade it in
      @anims[id].setEnabled(true)
      @anims[id].setWeight(0)
      @fadingOut[id] = false
      @fadingIn[id] = true
      @anims[id].setTimePosition(0) if (reset) 
    end
  end

  def updateBody(deltaTime)
    @goalDirection = Ogre::Vector3.new(0, 0, 0) # we will calculate this

    if (!@keyDirection.isZeroLength && @baseAnimID != ANIM_DANCE)

      # calculate actually goal direction in world based on player's key directions
      @goalDirection += @cameraMover.camera.getOrientation().zAxis() * @keyDirection.z
      @goalDirection += @cameraMover.camera.getOrientation().xAxis() * @keyDirection.x
      @goalDirection.y = 0
      @goalDirection.normalise()

      zDirection = @cameraMover.camera.getOrientation().zAxis()

      toGoal = @bodyNode.getOrientation().zAxis().getRotationTo(@goalDirection)

      # calculate how much the character has to turn to face goal direction
      yawToGoal = toGoal.getYaw().valueDegrees()
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
                        
      @bodyNode.yaw(Ogre::Radian.new(Ogre::Degree.new(yawToGoal).valueRadians()))

      # move in current body direction (not the goal direction)
      @bodyNode.translate(0, 0, deltaTime * RUN_SPEED * @anims[@baseAnimID].getWeight(),
                          Ogre::Node::TS_LOCAL)
    end

    if (@baseAnimID == ANIM_JUMP_LOOP)
      # if we're jumping, add a vertical offset too, and apply gravity
      @bodyNode.translate(0, @verticalVelocity * deltaTime, 0, Ogre::Node::TS_LOCAL)
      @verticalVelocity -= GRAVITY * deltaTime;
                        
      pos = @bodyNode.getPosition()
      if (pos.y <= CHAR_HEIGHT)
        # if we've hit the ground, change to landing state
        pos.y = CHAR_HEIGHT
        @bodyNode.setPosition(pos)
        setBaseAnimation(ANIM_JUMP_END, true)
        @timer = 0
      end
    end
  end

  def updateAnimations(deltaTime)
    baseAnimSpeed = 1
    topAnimSpeed = 1

    @timer += deltaTime

    if (@topAnimID == ANIM_DRAW_SWORDS)
      # flip the draw swords animation if we need to put it back
      topAnimSpeed = @swordsDrawn ? -1 : 1

      # half-way through the animation is when the hand grasps the handles...
      if (@timer >= @anims[@topAnimID].getLength() / 2 &&
          @timer - deltaTime < @anims[@topAnimID].getLength() / 2)
        # so transfer the swords from the sheaths to the hands
        @bodyEnt.detachAllObjectsFromBone()
        @bodyEnt.attachObjectToBone(@swordsDrawn ? "Sheath.L" : "Handle.L", @sword1)
        @bodyEnt.attachObjectToBone(@swordsDrawn ? "Sheath.R" : "Handle.R", @sword2)
        # change the hand state to grab or let go
        @anims[ANIM_HANDS_CLOSED].setEnabled(!@swordsDrawn)
        @anims[ANIM_HANDS_RELAXED].setEnabled(@swordsDrawn)

        # toggle sword trails
        if (@swordsDrawn)
          @swordTrail.setVisible(false)
          @swordTrail.removeNode(@sword1.getParentNode())
          @swordTrail.removeNode(@sword2.getParentNode())
        else
          @swordTrail.setVisible(true)
          @swordTrail.addNode(@sword1.getParentNode())
          @swordTrail.addNode(@sword2.getParentNode())
        end
      end

      if (@timer >= @anims[@topAnimID].getLength())
        # animation is finished, so return to what we were doing before
        if (@baseAnimID == ANIM_IDLE_BASE) 
          setTopAnimation(ANIM_IDLE_TOP)
        else
          setTopAnimation(ANIM_RUN_TOP)
          @anims[ANIM_RUN_TOP].setTimePosition(@anims[ANIM_RUN_BASE].getTimePosition())
        end
        @swordsDrawn = !@swordsDrawn
      end

    elsif (@topAnimID == ANIM_SLICE_VERTICAL || @topAnimID == ANIM_SLICE_HORIZONTAL)
      if (@timer >= @anims[@topAnimID].getLength())
        # animation is finished, so return to what we were doing before
        if (@baseAnimID == ANIM_IDLE_BASE) 
          setTopAnimation(ANIM_IDLE_TOP)
        else
          setTopAnimation(ANIM_RUN_TOP)
          @anims[ANIM_RUN_TOP].setTimePosition(@anims[ANIM_RUN_BASE].getTimePosition())
        end
      end
      # don't sway hips from side to side when slicing. that's just embarrasing.
      baseAnimSpeed = 0 if (@baseAnimID == ANIM_IDLE_BASE) 

    elsif (@baseAnimID == ANIM_JUMP_START)
      if (@timer >= @anims[@baseAnimID].getLength())
        # takeoff animation finished, so time to leave the ground!
        setBaseAnimation(ANIM_JUMP_LOOP, true)
        # apply a jump acceleration to the character
        @verticalVelocity = JUMP_ACCEL
      end
    elsif (@baseAnimID == ANIM_JUMP_END)
      if (@timer >= @anims[@baseAnimID].getLength())
        # safely landed, so go back to running or idling
        if (@keyDirection.isZeroLength)
          setBaseAnimation(ANIM_IDLE_BASE)
          setTopAnimation(ANIM_IDLE_TOP)
        else
          setBaseAnimation(ANIM_RUN_BASE, true)
          setTopAnimation(ANIM_RUN_TOP, true)
        end
      end
    end
    # increment the current base and top animation times
    @anims[@baseAnimID].addTime(deltaTime * baseAnimSpeed) if (@baseAnimID != ANIM_NONE) 
    @anims[@topAnimID].addTime(deltaTime * topAnimSpeed) if (@topAnimID != ANIM_NONE) 
    
    # apply smooth transitioning between our animations
    fadeAnimations(deltaTime)
  end

  def clamp(value, min, max)
    return max if (value > max)
    return min if (value < min)
    return value
  end
  
  def fadeAnimations(deltaTime)
    NUM_ANIMS.times {|i|
      if (@fadingIn[i])
        # slowly fade this animation in until it has full weight
        newWeight = @anims[i].getWeight() + deltaTime * ANIM_FADE_SPEED
        @anims[i].setWeight(clamp(newWeight, 0, 1))
        @fadingIn[i] = false if (newWeight >= 1) 

      elsif (@fadingOut[i])
        # slowly fade this animation out until it has no weight, and then disable it
        newWeight = @anims[i].getWeight() - deltaTime * ANIM_FADE_SPEED
        @anims[i].setWeight(clamp(newWeight, 0, 1))
        if (newWeight <= 0)
          @anims[i].setEnabled(false)
          @fadingOut[i] = false
        end
      end
    }
  end

  def addTime(delta)
    updateBody(delta)
    updateAnimations(delta)
  end

  def injectKeyDown(evt)
    if (evt.key == OIS::KC_Q && (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP))
      # take swords out (or put them back, since it's the same animation but reversed)
      setTopAnimation(ANIM_DRAW_SWORDS, true)
      @timer = 0
    elsif (evt.key == OIS::KC_E && !@swordsDrawn)
      if (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP)
        # start dancing
        setBaseAnimation(ANIM_DANCE, true)
        setTopAnimation(ANIM_NONE)
        # disable hand animation because the dance controls hands
        @anims[ANIM_HANDS_RELAXED].setEnabled(false)
      elsif (@baseAnimID == ANIM_DANCE)
        # stop dancing
        setBaseAnimation(ANIM_IDLE_BASE)
        setTopAnimation(ANIM_IDLE_TOP);
        # re-enable hand animation
        @anims[ANIM_HANDS_RELAXED].setEnabled(true)
      end
    # keep track of the player's intended direction
    elsif (evt.key == OIS::KC_W) 
      @keyDirection.z = -1
    elsif (evt.key == OIS::KC_A) 
      @keyDirection.x = -1
    elsif (evt.key == OIS::KC_S) 
      @keyDirection.z = 1
    elsif (evt.key == OIS::KC_D) 
      @keyDirection.x = 1
    elsif (evt.key == OIS::KC_SPACE && (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP))
      # jump if on ground
      setBaseAnimation(ANIM_JUMP_START, true)
      setTopAnimation(ANIM_NONE)
      @timer = 0
    end

    if (!@keyDirection.isZeroLength() && @baseAnimID == ANIM_IDLE_BASE)
      # start running if not already moving and the player wants to move
      setBaseAnimation(ANIM_RUN_BASE, true)
      setTopAnimation(ANIM_RUN_TOP, true) if (@topAnimID == ANIM_IDLE_TOP) 
    end
    
  end

  def injectKeyUp(evt)
    # keep track of the player's intended direction
    if (evt.key == OIS::KC_W && @keyDirection.z == -1) 
      @keyDirection.z = 0 
    elsif (evt.key == OIS::KC_A && @keyDirection.x == -1) 
      @keyDirection.x = 0
    elsif (evt.key == OIS::KC_S && @keyDirection.z == 1) 
      @keyDirection.z = 0
    elsif (evt.key == OIS::KC_D && @keyDirection.x == 1) 
      @keyDirection.x = 0
    end

    if (@keyDirection.isZeroLength() && @baseAnimID == ANIM_RUN_BASE)
      # stop running if already moving and the player doesn't want to move
      setBaseAnimation(ANIM_IDLE_BASE);
      setTopAnimation(ANIM_IDLE_TOP) if (@topAnimID == ANIM_RUN_TOP) 
    end
  end

  def injectMouseDown(evt, id)
    if (@swordsDrawn && (@topAnimID == ANIM_IDLE_TOP || @topAnimID == ANIM_RUN_TOP))
      # if swords are out, and character's not doing something weird, then SLICE!
      if (id == OIS::MB_Left) 
        setTopAnimation(ANIM_SLICE_VERTICAL, true) 
      elsif (id == OIS::MB_Right) 
        setTopAnimation(ANIM_SLICE_HORIZONTAL, true)
      end
      @timer = 0
    end
  end

end
