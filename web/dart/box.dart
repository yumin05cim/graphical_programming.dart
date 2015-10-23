part of graphical_programming;


class BoxSprite extends stagexl.Sprite {

  List<PortSprite> outports = [];
  List<PortSprite> inports = [];
  GraphicalScriptEditor owner;
  int id;
  connection_model.Box box;

  BoxSprite.Box(this.owner, this.box) {
    this.id = box.id;
    // draw the key
    var bitmapData = owner.resourceManager.getBitmapData("box");
    var bitmap = new stagexl.Bitmap(bitmapData);
    this.addChild(bitmap);

    _setupTitle(box.boxName);
    this.useHandCursor = true;
    _setupHandler();
    this.x = box.position.x;
    this.y = box.position.y;

    for(connection_model.InPort p in box.inports) {
      addInPortObj(p);
    }

    for(connection_model.InPort p in box.outports) {
      addOutPortObj(p);
    }
  }


  BoxSprite(this.owner, this.id, String boxTitle, int x, int y) {

    // draw the key
    var bitmapData = owner.resourceManager.getBitmapData("box");
    var bitmap = new stagexl.Bitmap(bitmapData);
    this.addChild(bitmap);


    _setupTitle(boxTitle);
    // add event handlers
    this.useHandCursor = true;
    _setupHandler();
    this.x = x;
    this.y = y;
  }

  void _setupTitle(String boxTitle) {
    var title = new stagexl.TextField()
      ..text = boxTitle
      ..x = this.width / 2
      ..y = 20;
    title.x = title.x - (title.textWidth/2).toInt();
    title.width = title.textWidth;
    title.height = title.textHeight;
    this.addChild(title);
  }

  void _setupHandler() {
    this.onMouseDown.listen(_keyDown);
    //this.onMouseOver.listen(_keyDown);
    this.onMouseUp.listen(_keyUp);
    //this.onMouseOut.listen(_keyUp);
    this.onMouseMove.listen(_keyMove);
    this.onMouseOut.listen(_keyUp);
  }

  void _addOutPortSprite(OutPortSprite port) {
    port
      ..x = this.x + 100
      ..y = this.y + 20 + outports.length * 30;
    outports.add(port);
    owner.stage.addChild(port);
  }

  void addOutPortObj(connection_model.OutPort outport) {
    var port = new OutPortSprite.Port(this, outport);
    _addOutPortSprite(port);
    return port;
  }

  void addOutPort(String name) {
    var port = new OutPortSprite(this, name);
    _addOutPortSprite(port);
    return port;
  }

  void _addInPortSprite(InPortSprite port) {
    port
      ..x = this.x - 20
      ..y = this.y + 20 + inports.length * 30;
    inports.add(port);
    owner.stage.addChild(port);
  }

  void addInPortObj(connection_model.InPort inport) {
    var port = new InPortSprite.Port(this, inport);
    _addInPortSprite(port);
    return port;
  }

  void addInPort(String name) {
    var port = new InPortSprite(this, name);
    _addInPortSprite(port);
    return port;
  }

  bool down = false;
  MouseEvent e0;
  int x0;
  int y0;
  int downX0;
  int downY0;

  _keyDown(MouseEvent me) {
    down = true;
    e0 = me;
    x0 = this.x;
    downX0 = e0.stageX;
    y0 = this.y;
    downY0 = e0.stageY;
  }

  _keyMove(MouseEvent me) {
    if(down) {
      int x = me.stageX;
      int y = me.stageY;
      int dx = ( x - downX0 );
      int dy = ( y - downY0 );
      int vx = x0 + dx - this.x;
      int vy = y0 + dy - this.y;
      this.x = x0 + dx;
      this.y = y0 + dy;

      for(OutPortSprite op in outports) {
        op.x = op.x + vx;
        op.y = op.y + vy;
      }
      for(InPortSprite ip in inports) {
        ip.x = ip.x + vx;
        ip.y = ip.y + vy;
      }

      owner.updateConnectionShape();
    }
  }

  _keyUp(MouseEvent me) {
    down = false;
  }
}
