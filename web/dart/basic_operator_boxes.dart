part of graphical_programming;

class AddBox extends BoxSprite {
  AddBox(GraphicalScriptEditor owner, int id, int x, int y) : super(owner, id, 'Add', x, y) {
    addOutPort('out');
    addInPort('in0');
    addInPort('in1');
  }
}

class VariableBox extends BoxSprite {
  VariableBox(GraphicalScriptEditor owner, int id, String name, int x, int y) : super(owner, id, 'Variable(name=${name})', x, y) {
    addInPort('in0');
  }
}

class StatementBox extends BoxSprite {
  OutPortSprite next;
  InPortSprite previous;
  connection_model.Statement statement;
  StatementBox(GraphicalScriptEditor owner, int id, this.statement, int x, int y) : super(owner, id, 'Statement', x, y) {
    next = addOutPort('next');
    previous = addInPort('previous');

    this.onMouseClick.listen(onclicked);
  }

  StatementBox.Statement(GraphicalScriptEditor owner, connection_model.Statement statement) : super(owner, statement.id, 'Statement', statement.position.x, statement.position.y) {
    this.statement = statement;
    this.box = statement;
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
  onclicked(stagexl.MouseEvent me) {
    if (me.localX < 20 && me.localY >= 180) {
      owner.modelLoader.focus(statement);
      owner.updateView();
    }
  }
}