part of graphical_programming;


class PortSprite extends stagexl.Sprite {

  String name;
  BoxSprite owner;

  connection_model.Port port;

  PortSprite.Port(this.owner, this.port, String typename) {
    this.name = port.name;
    _setupBitmap(typename);
    _setupMouse();
  }

  PortSprite(this.owner, this.name, String typename) {
    _setupBitmap(typename);
    _setupMouse();
  }

  _setupBitmap(String typename) {
    var bitmapData = owner.owner.resourceManager.getBitmapData(typename);
    var bitmap = new stagexl.Bitmap(bitmapData);
    this.addChild(bitmap);
  }

  _setupMouse() {

    //this.onMouseOver.listen(_keyOver);
    this.onMouseDown.listen(_keyDown);
    //this.onMouseOver.listen(_keyDown);
    this.onMouseUp.listen(_keyUp);
    //this.onMouseOut.listen(_keyUp);
    this.onMouseMove.listen(_keyMove);
    //this.onMouseOut.listen(_keyUp);
  }


  _keyDown(stagexl.MouseEvent me) {
    owner.owner.portDragging = this;
  }

  _keyMove(stagexl.MouseEvent me) {
  }

  _keyUp(stagexl.MouseEvent me) {
    if (owner.owner.portDragging != null) {
      if (owner.owner.portDragging != this) {
        owner.owner.onConnect(this, owner.owner.portDragging);
      }
    }
  }


  void connect(PortSprite port) {
    var c = new ConnectionSprite(this, port);
    //owner.owner.connections.add(c);
    owner.owner.stage.addChild(c);
    if (this.port != null) {
      this.port.connect(port.port);
    }
  }
}

class InPortSprite extends PortSprite {
  InPortSprite.Port(BoxSprite owner, connection_model.InPort port) : super.Port(owner, port, 'inport');
  InPortSprite(BoxSprite owner, String name) : super(owner, name, 'inport');
}

class OutPortSprite extends PortSprite {
  OutPortSprite.Port(BoxSprite owner, connection_model.OutPort port) : super.Port(owner, port, 'outport');
  OutPortSprite(BoxSprite owner, String name) : super(owner, name, 'outport');
}