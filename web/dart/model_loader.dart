
part of graphical_programming;


class ModelLoader {

  stagexl.ResourceManager resourceManager;
  GraphicalScriptEditor owner;
  connection_model.Application application;
  var focusingModel = null;

  ModelLoader({connection_model.Application application : null}) {
    this.application = application;
    if (this.application == null) {
      this.application = new connection_model.Application();
    }
    this.focus(this.application);
  }


  void loadApplication(stagexl.Stage stage) {
    this.application.iterStatement((connection_model.Statement s) {
      var b = new StatementBox(this.owner, s.id, s, 100, 100);
      stage.addChild(b);
      if (connection_model.Application.previousStatement(s) != null) {
        var pairs = [];
        for(var box in stage.children) {
          if (box is StatementBox) {
            if ((box as StatementBox).id == connection_model.Application.previousStatement(s).id) {
              //b.previous.connect(box.next);
              pairs.add([b.previous, box.next]);
            }
          }
        }

        for(var pair in pairs) {
          pair[0].connect(pair[1]);
        }

      }
    });
  }

  void loadStatement(stagexl.Stage stage) {
    for(connection_model.Box box in (focusingModel as connection_model.Statement).boxes) {
      stage.addChild(parseBox(box));
    }

    var connections = [];
    for(connection_model.Box box in (focusingModel as connection_model.Statement).boxes) {
      box.inports.forEach((p) {
        for (connection_model.Connection con in p.connections) {
          if (connections.indexOf(con) < 0) {
            connections.add(con);
          }
        }
      });
      box.outports.forEach((p) {
        for (connection_model.Connection con in p.connections) {
          if (connections.indexOf(con) < 0) {
            connections.add(con);
          }
        }
      });
    }

    connections.forEach((con) {
      stage.addChild(new ConnectionSprite.Connection(stage, con));
    });



  }

  BoxSprite parseBox(connection_model.Box box) {
    return new BoxSprite.Box(this.owner, box);
  }

  void loadToStage(stagexl.Stage stage) {
    stage.children.clear();
    if (focusingModel == this.application) {
      loadApplication(stage);
    } else if (focusingModel is connection_model.Statement) {
      loadStatement(stage);
    }
  }

  void focus(var model) {
    focusingModel = model;
  }


}