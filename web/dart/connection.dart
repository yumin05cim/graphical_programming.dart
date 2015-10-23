part of graphical_programming;

class InvalidModelException implements Exception {
  const InvalidModelException();
}

class ConnectionSprite extends stagexl.Sprite {

  InPortSprite inport = null;
  OutPortSprite outport = null;
  connection_model.Connection connection;
  stagexl.Shape shape = new stagexl.Shape();
  ConnectionSprite.Connection(stagexl.Stage stage, this.connection) {
    connection_model.InPort ip = connection.ports[0] is connection_model.InPort ? connection.ports[0] : connection.ports[1];
    connection_model.OutPort op = connection.ports[0] is connection_model.OutPort ? connection.ports[0] : connection.ports[1];
    for(var box in stage.children) {
      if (box is PortSprite) {
        if ((box as PortSprite).port == ip) {
          inport = box;
        } else if ((box as PortSprite).port == op)  {
          outport = box;
        }
      }
    }
    if (inport == null || outport == null) {
      // Error
      throw new InvalidModelException();
    }
    updateShape();
    this.addChild(shape);
  }

  ConnectionSprite(PortSprite port0, PortSprite port1) {
    if (port0 is InPortSprite) {
      inport = port0;
      outport = port1;
    } else {
      inport = port1;
      outport = port0;
    }
    updateShape();
    this.addChild(shape);
  }

  void updateShape() {
    shape
      ..graphics.clear()
      ..graphics.beginPath()
      ..graphics.moveTo(inport.x + 10, inport.y + 10)
      ..graphics.lineTo(outport.x + 10, outport.y + 10)
      ..graphics.closePath()
      ..graphics.strokeColor(stagexl.Color.Green, 3);
  }

}