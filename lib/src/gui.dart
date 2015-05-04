part of cf_dart;

class CF {
  JsObject _CF;
  dynamic _userMain;
  JsFunction _watch;
  JsFunction _getJoin;
  JsFunction _getJoins;
  JsFunction _setJoin;
  JsFunction _setJoins;
  JsFunction _setToken;
  JsFunction _addTag;
  JsFunction _addTags;
  JsFunction _removeTag;
  JsFunction _getProperties;
  JsFunction _setProperties;

  CF() {
    _CF = context['CF'];
    _userMain = _CF['userMain'];
    _getJoin = _CF['getJoin'];
    _getJoins = _CF['getJoins'];
    _setJoin = _CF['setJoin'];
    _setJoins = _CF['setJoins'];
    _setToken = _CF['setToken'];
    _addTag = _CF['addTag'];
    _addTags = _CF['addTags'];
    _removeTag = _CF['removeTag'];
    _getProperties = _CF['getProperties'];
    _setProperties = _CF['setProperties'];
  }

  Future get userMain async {
    Completer c = new Completer();

    var callbackFunc = () {
      c.complete();
    };

    _userMain = callbackFunc;

    return c.future;
  }

  Future<Join> getJoin(String join) async {
    Completer c = new Completer();

    var callbackFunc = (String join, dynamic value, JsObject tokens, [JsArray tags]) {
      if (value == null) {
        value = null;
        tokens = null;
        tags = null;
      }
      Join joinObject = new Join.fromJsObject(join, value, tokens, tags);
      c.complete(joinObject);
    };

    _getJoin.apply([join, callbackFunc]);

    return c.future;
  }

  Future<Map<String, Join>> getJoins(List<String> joins) async {
    Completer c = new Completer();

    var callbackFunc = (JsObject joinsMap) {
      Map<String, Join> dartJoinsMap = {};
      joins.forEach((join) {
        var joinValue = joinsMap[join];
        if (joinValue != null) {
          var value = joinValue['value'];
          var tokens = joinValue['tokens'];
          var tags = joinValue['tags'];
          dartJoinsMap[join] = new Join.fromJsObject(join, value, tokens, tags);
        }
      });
      c.complete(dartJoinsMap);
    };
    _getJoins.apply([new JsObject.jsify(joins), callbackFunc]);

    return c.future;
  }

  void setJoin(String join, dynamic value, [bool sendJoinChangeEvent]) {
    sendJoinChangeEvent = sendJoinChangeEvent == null ? true : sendJoinChangeEvent;
    _setJoin.apply([join, value, sendJoinChangeEvent]);
  }

  void setJoins(List<Join> joins, [bool sendJoinChangeEvent]) {
    sendJoinChangeEvent = sendJoinChangeEvent == null ? true : sendJoinChangeEvent;
    Map joinsMap = {};

    if (joins != null) {
      joins.forEach((join) {
        Map joinMap = {};

        if (join.value != null) {
          joinMap['value'] = join.value;
          if (join.tokens != null) {
            joinMap['tokens'] = join.tokens;
          }
          joinsMap[join.join] = joinMap;
        }
      });
    }

    _setJoins.apply([new JsObject.jsify(joinsMap), sendJoinChangeEvent]);
  }

  void setToken(String join, String token, dynamic value) {
    _setToken.apply([join, token, value]);
  }

  void addTag(String join, String tag) {
    _addTag.apply([join, tag]);
  }

  void addTags(List<String> joins, String tag) {
    _addTags.apply([new JsObject.jsify(joins), tag]);
  }

  void removeTagFromAllJoins(String tag) {
    _removeTag.apply([tag]);
  }

  void removeTagFromJoin(String join, String tag) {
    _removeTag.apply([join, tag]);
  }

  void removeTagFromJoins(List<String> joins, String tag) {
    _removeTag.apply([new JsObject.jsify(joins), tag]);
  }

  Future<JoinProperties> getJoinProperties(String join) async {
    Map<String, JoinProperties> joinProperties = await getMultipleJoinProperties([join]);
    return joinProperties[join];
  }

  Future<Map<String, JoinProperties>> getMultipleJoinProperties(List<String> joins) async {
    Completer c = new Completer();

    var callbackFunc = (JsArray returnedJoins) {
      Map<String, JoinProperties> joinProperties = {};

      for (var joinIdx = 0; joinIdx < returnedJoins.length; joinIdx++) {
        JsObject joinObject = returnedJoins[joinIdx];
        String join = joinObject['join'];
        print(join);

        if (joinObject != null) {
          joinProperties[join] = new JoinProperties(
              join: join,
              x: joinObject['x'],
              y: joinObject['y'],
              width: joinObject['width'],
              height: joinObject['height'],
              xRotation: joinObject['xRotation'],
              yRotation: joinObject['yRotation'],
              zRotation: joinObject['zRotation'],
              scale: joinObject['scale'],
              opacity: joinObject['opacity'],
              theme: joinObject['theme']
          );
        }
      }

      c.complete(joinProperties);
    };

    _getProperties.apply([new JsObject.jsify(joins), callbackFunc]);

    return c.future;
  }

  Future setJoinProperties(JoinProperties join, num delay, num duration, num curve) async {
    await setMultipleJoinProperties([join], delay, duration, curve);
  }

  Future setMultipleJoinProperties(List<JoinProperties> joins, num delay, num duration, num curve) async {
    Completer c = new Completer();

    var callbackFunc = () {
      c.complete();
    };

    List<Map> changes = [];
    joins.forEach((joinProp) {
      Map joinPropertiesMap = {};
      if (joinProp.x != null) {
        joinPropertiesMap['x'] = joinProp.x;
      }
      if (joinProp.y != null) {
        joinPropertiesMap['y'] = joinProp.y;
      }
      if (joinProp.width != null) {
        joinPropertiesMap['w'] = joinProp.width;
      }
      if (joinProp.height != null) {
        joinPropertiesMap['h'] = joinProp.height;
      }
      if (joinProp.xRotation != null) {
        joinPropertiesMap['xrotation'] = joinProp.xRotation;
      }
      if (joinProp.yRotation != null) {
        joinPropertiesMap['yrotation'] = joinProp.yRotation;
      }
      if (joinProp.zRotation != null) {
        joinPropertiesMap['zrotation'] = joinProp.zRotation;
      }
      if (joinProp.scale != null) {
        joinPropertiesMap['scale'] = joinProp.scale;
      }
      if (joinProp.theme != null) {
        joinPropertiesMap['theme'] = joinProp.theme;
      }
      changes.add(joinPropertiesMap);
    });

    _setProperties.apply([new JsObject.jsify(changes), delay, duration, curve, callbackFunc]);

    return c.future;
  }
}

class Join {
  String join;
  String value;
  JsObject tokens;
  JsArray tags;

  Join(this.join, value, [Map<String, String> tokens, List<String> tags]) {
    if (value != null) {
      this.value = value.toString();
    }
    if (tokens != null) {
      this.tokens = new JsObject.jsify(tokens);
    }
    if (tags != null) {
      this.tags = new JsObject.jsify(tags);
    }
  }

  Join.fromJsObject(this.join, value, [this.tokens, this.tags]) {
    if (value != null) {
      this.value = value.toString();
    }
  }
}

class JoinProperties {
  String join;
  num x;
  num y;
  num width;
  num height;
  num xRotation;
  num yRotation;
  num zRotation;
  num scale;
  num opacity;
  String theme;

  JoinProperties({String join, num x, num y, num width, num height, num xRotation, num yRotation, num zRotation, num scale, num opacity, String theme}) {
    this.join = join;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.xRotation = xRotation;
    this.yRotation = yRotation;
    this.zRotation = zRotation;
    this.scale = scale;
    this.opacity = opacity;
    this.theme = theme;
  }
}
