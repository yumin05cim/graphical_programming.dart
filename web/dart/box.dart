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

    for(connection_model.OutPort p in box.outports) {
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

  OutPortSprite addOutPortObj(connection_model.OutPort outport) {
    var port = new OutPortSprite.Port(this, outport);
    _addOutPortSprite(port);
    return port;
  }

  OutPortSprite addOutPort(String name) {
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

  InPortSprite addInPortObj(connection_model.InPort inport) {
    var port = new InPortSprite.Port(this, inport);
    _addInPortSprite(port);
    return port;
  }

  InPortSprite addInPort(String name) {
    var port = new InPortSprite(this, name);
    _addInPortSprite(port);
    return port;
  }

  bool down = false;
  stagexl.MouseEvent e0;
  var x0;
  var y0;
  var downX0;
  var downY0;

  _keyDown(stagexl.MouseEvent me) {
    down = true;
    e0 = me;
    x0 = this.x;
    downX0 = e0.stageX;
    y0 = this.y;
    downY0 = e0.stageY;
  }

  _keyMove(stagexl.MouseEvent me) {
    if(down) {
      var x = me.stageX;
      var y = me.stageY;
      var dx = ( x - downX0 );
      var dy = ( y - downY0 );
      var vx = x0 + dx - this.x;
      var vy = y0 + dy - this.y;
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

  _keyUp(stagexl.MouseEvent me) {
    down = false;
  }
}
