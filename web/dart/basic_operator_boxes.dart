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

  onclicked(stagexl.MouseEvent me) {
    if (me.localX < 20 && me.localY >= 180) {
      owner.modelLoader.focus(statement);
      owner.updateView();
    }
  }
}