#
# Key Listener
#
class KeyListener < OIS::KeyListener
  def initialize(listener)
    super()
    @listener = listener
  end
  
  def keyPressed(keyEvent)
    return @listener.keyPressed(keyEvent)
  end
  
  def keyReleased(keyEvent)
    return @listener.keyReleased(keyEvent)
  end
end

#
# Mouse Listener
#
class MouseListener < OIS::MouseListener
  def initialize(listener)
    super()
    @listener = listener
  end
  
  def mouseMoved(evt)
    return @listener.mouseMoved(evt)
  end
  
  def mousePressed(mouseEvent, mouseButtonID)
    return @listener.mousePressed(mouseEvent, mouseButtonID)
  end
  
  def mouseReleased(mouseEvent, mouseButtonID)
    return @listener.mouseReleased(mouseEvent, mouseButtonID)
  end
end

#
# Tray Listener
#
class TrayListener < OgreBites::SdkTrayListener
  def initialize(listener)
    super()
    @listener = listener
  end

  def buttonHit(button)
    @listener.buttonHit(button)
  end

  def itemSelected(menu)
    @listener.itemSelected(menu)
  end

  def yesNoDialogClosed(name, bl)
    @listener.yesNoDialogClosed(name, bl)
  end

  def okDialogClosed(name)
    @listener.okDialogClosed(name)
  end
end
