library graphical_programming;

import 'dart:core';
import 'dart:math';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart' as stagexl;
import 'package:connection_model/connection.dart' as connection_model;
import 'package:connection_program_converter/converter.dart' as converter;
part 'box.dart';
part 'basic_operator_boxes.dart';
part 'port.dart';
part 'model_loader.dart';
part 'connection.dart';


class IntegerLiteralBox extends BoxSprite {
  IntegerLiteralBox(GraphicalScriptEditor owner, int id, int value, int x, int y) : super(owner, id, 'Integer(value=$value)', x, y) {
    addOutPort('out');
  }
}

class GraphicalScriptEditor {

  PortSprite portDragging = null;

  stagexl.RenderLoop renderLoop = new stagexl.RenderLoop();
  stagexl.ResourceManager resourceManager = new stagexl.ResourceManager();
  stagexl.Stage stage;

  ModelLoader modelLoader = null;

  GraphicalScriptEditor(html.HtmlElement element, {ModelLoader modelLoader : null}) {
    //stagexl.StageXL.stageOptions.renderEngine = stagexl.RenderEngine.WebGL;
    stagexl.StageXL.stageOptions.renderEngine = stagexl.RenderEngine.Canvas2D;
    stagexl.StageXL.stageOptions.backgroundColor = stagexl.Color.Yellow;

    if (modelLoader == null) {
      this.modelLoader = new ModelLoader();
    } else {
      this.modelLoader = modelLoader;
    }


    resourceManager.addBitmapData('box', 'box.png');
    resourceManager.addBitmapData('inport', 'inport.png');
    resourceManager.addBitmapData('outport', 'outport.png');

    this.modelLoader.resourceManager = resourceManager;
    this.modelLoader.owner = this;
    this.stage = new stagexl.Stage(element);

    renderLoop.addStage(stage);
    resourceManager.load()
    .then((_) {
      this.modelLoader.focus(this.modelLoader.application);
      this.updateView();
      //renderLoop.start();
      // stage_.applyCache();

      //stage.children.clear();
    });

    stagexl.Shape connectorLine = null;

    stage.onMouseClick.listen((stagexl.MouseEvent me) {
      if (me.stageX < 20 && me.stageY > stage.height - 20) {
        converter.Converter cnvt= new converter.Converter();
        var program = cnvt.convert(modelLoader.application);
        print (program.toPython(0));
      } else if (me.stageX < 20 && me.stageY < 20) {
        if (modelLoader.focusingModel != modelLoader.application) {
          modelLoader.focus(modelLoader.application);
          updateView();
        }
      }
    });
    stage.onMouseMove.listen((MouseEvent me) {
      if (portDragging != null) {
        if (connectorLine == null) {
          connectorLine = new stagexl.Shape();
        }
        connectorLine.graphics.clear();
        connectorLine
          ..graphics.beginPath()
          ..graphics.moveTo(portDragging.x + 10, portDragging.y + 10)
          ..graphics.lineTo(me.stageX, me.stageY)
          ..graphics.closePath()
          ..graphics.strokeColor(stagexl.Color.Pink);
        stage.addChild(connectorLine);

      }
    });

    stage.onMouseUp.listen((MouseEvent me) {
      if (connectorLine != null) {
        stage.removeChild(connectorLine);
        connectorLine = null;
        portDragging = null;
      }
    });
  }

  void updateView() {
    this.modelLoader.loadToStage(stage);
  }
  //List<ConnectionSprite> connections = [];

  void onConnect(PortSprite port0, PortSprite port1) {
    if ((port0 is InPortSprite && port1 is InPortSprite) ||
    (port0 is OutPortSprite && port1 is OutPortSprite)) {
      // do nothing
    } else {
      port0.connect(port1);

    }
  }

  void updateConnectionShape() {
    for(var c in stage.children) {
      if (c is ConnectionSprite) {
        c.updateShape();
      }
    }
  }
}
