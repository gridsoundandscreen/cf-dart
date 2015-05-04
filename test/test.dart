import 'package:test/test.dart';
import 'dart:js';
import 'dart:html';
import 'package:cf_dart/cf-dart/src/cf.dart';

var lastCallArgs = context['CF']['lastCallArgs'];

void main() {
  group('getJoin', () {
    test('should work with a join that is defined', () async {
      CF cf = new CF();
      Join join = await cf.getJoin('d1');
      expect(join.value, equals('1'));
      expect(join.join, equals('d1'));
      expect(join.tokens['[join]'], equals('d1'));
      expect(join.tags[0], equals('d1'));
    });
    test('should work with a join that is undefined', () async {
      CF cf = new CF();
      Join join = await cf.getJoin('d2');
      expect(join.value, equals(null));
      expect(join.join, equals('d2'));
      expect(join.tokens, equals(null));
      expect(join.tags, equals(null));
    });
  });
  
  group('getJoins', () {
    test('should work with mixed collection of defined and undefined joins', () async {
      CF cf = new CF();
      Map<String, Join> joins = await cf.getJoins(['d0', 'd1']);
      expect(joins['d1'], isNot(null));
      expect(joins['d0'], equals(null));
      expect(joins['d3'], equals(null));
    });
  });

  group('setJoin', () {
    test('should set the value of a join', () {
      CF cf = new CF();
      cf.setJoin('d1', 'testValue');
      expect(context['CF']['joins']['d1']['value'], equals('testValue'));
    });
    test('should send a join change event by default', () {
      CF cf = new CF();
      cf.setJoin('d1', 'testValue');
      expect(context['CF']['joins']['d1']['sentJoinChangeEvent'], equals(true));
    });
    test('should send a join change event is sendJoinChangeEvent is passed as true', () {
      CF cf = new CF();
      cf.setJoin('d1', 'testValue', true);
      expect(context['CF']['joins']['d1']['sentJoinChangeEvent'], equals(true));
    });
    test('shouldnt send a join change event is sendJoinChangeEvent is passed as false', () {
      CF cf = new CF();
      cf.setJoin('d1', 'testValue', false);
      expect(context['CF']['joins']['d1']['sentJoinChangeEvent'], equals(false));
    });
  });

  group('setJoins', () {
    test('should call CF.setJoins with the correct arguments', () {
      CF cf = new CF();
      Join join1 = new Join('d1', 0, {'token1': 'tokenValue1', 'token2': 'tokenValue2'});
      Join join2 = new Join('d2', 0, null);
      cf.setJoins([join1, join2]);
      expect(lastCallArgs['setJoins'][0]['d1']['value'], equals('0'));
      expect(lastCallArgs['setJoins'][0]['d1']['tokens']['token1'], equals('tokenValue1'));
      expect(lastCallArgs['setJoins'][0]['d1']['tokens']['token2'], equals('tokenValue2'));
      expect(lastCallArgs['setJoins'][0]['d2']['value'], equals('0'));
      expect(lastCallArgs['setJoins'][0]['d2']['tokens'], equals(null));
    });
    test('should send a join change event by default', () {
      CF cf = new CF();
      Join join1 = new Join('d1', 0, {'token1': 'tokenValue1', 'token2': 'tokenValue2'});
      cf.setJoins([join1]);
      expect(lastCallArgs['setJoins'][1], equals(true));
    });
    test('should send a join change event is sendJoinChangeEvent is passed as true', () {
      CF cf = new CF();
      Join join1 = new Join('d1', 0, {'token1': 'tokenValue1', 'token2': 'tokenValue2'});
      cf.setJoins([join1], true);
      expect(lastCallArgs['setJoins'][1], equals(true));
    });
    test('shouldnt send a join change event is sendJoinChangeEvent is passed as false', () {
      CF cf = new CF();
      Join join1 = new Join('d1', 0, {'token1': 'tokenValue1', 'token2': 'tokenValue2'});
      cf.setJoins([join1], false);
      expect(lastCallArgs['setJoins'][1], equals(false));
    });
  });

  group('setToken', () {
    test('should call CF.setToken with the correct arguments', () {
      CF cf = new CF();
      cf.setToken('d1', 'token1', 'value');
      expect(lastCallArgs['setToken'][0], equals('d1'));
      expect(lastCallArgs['setToken'][1], equals('token1'));
      expect(lastCallArgs['setToken'][2], equals('value'));
    });
  });

  group('addTag', () {
    test('should call CF.addTag with the correct arguments', () {
      CF cf = new CF();
      cf.addTag('d1', 'tag1');
      expect(lastCallArgs['addTag'][0], equals('d1'));
      expect(lastCallArgs['addTag'][1], equals('tag1'));
    });
  });

  group('addTags', () {
    test('should call CF.addTags with the correct arguments', () {
      CF cf = new CF();
      cf.addTags(['d1', 'd2'], 'tag1');
      expect(lastCallArgs['addTags'][0][0], equals('d1'));
      expect(lastCallArgs['addTags'][0][1], equals('d2'));
      expect(lastCallArgs['addTags'][1], equals('tag1'));
    });
  });

  group('removeTagFromAllJoins', () {
    test('should call CF.removeTag with the correct arguments', () {
      CF cf = new CF();
      cf.removeTagFromAllJoins('tag1');
      expect(lastCallArgs['removeTag'][0], equals('tag1'));
      expect(lastCallArgs['removeTag'][1], equals(null));
    });
  });

  group('removeTagFromJoin', () {
    test('should call CF.removeTag with the correct arguments', () {
      CF cf = new CF();
      cf.removeTagFromJoin('d1', 'tag1');
      expect(lastCallArgs['removeTag'][0], equals('d1'));
      expect(lastCallArgs['removeTag'][1], equals('tag1'));
      expect(lastCallArgs['removeTag'][2], equals(null));
    });
  });

  group('removeTagFromJoins', () {
    test('should call CF.removeTag with the correct arguments', () {
      CF cf = new CF();
      cf.removeTagFromJoins(['d1', 'd2'], 'tag1');
      expect(lastCallArgs['removeTag'][0][0], equals('d1'));
      expect(lastCallArgs['removeTag'][0][1], equals('d2'));
      expect(lastCallArgs['removeTag'][1], equals('tag1'));
      expect(lastCallArgs['removeTag'][2], equals(null));
    });
  });

  group('getMultipleJoinProperties', () {
    test('should call getProperties with the correct arguments', () async {
      CF cf = new CF();
      await cf.getMultipleJoinProperties(['d1']);
      expect(lastCallArgs['getProperties'][0][0], equals('d1'));
      expect(lastCallArgs['getProperties'][0].length, equals(1));
    });
    test('should receive a callback from JS with a Map of JoinProperties', () async {
      CF cf = new CF();
      Map<String, JoinProperties> props = await cf.getMultipleJoinProperties(['d1']);
      expect(lastCallArgs['getProperties'][0][0], equals('d1'));
      expect(lastCallArgs['getProperties'][0].length, equals(1));
      expect(props is Map<String, JoinProperties>, equals(true));
      expect(props['d1'] is JoinProperties, equals(true));
      expect(props['d1'].x, equals(0));
      expect(props['d1'].y, equals(50));
      expect(props['d1'].width, equals(320));
      expect(props['d1'].height, equals(100));
      expect(props['d1'].xRotation, equals(90));
      expect(props['d1'].yRotation, equals(180));
      expect(props['d1'].zRotation, equals(270));
      expect(props['d1'].scale, equals(1.1));
      expect(props['d1'].opacity, equals(0.5));
      expect(props['d1'].theme, equals('test_theme'));
    });
    test('should work for multiple joins', () async {
      CF cf = new CF();
      Map<String, JoinProperties> props = await cf.getMultipleJoinProperties(['d1', 'd2']);
      expect(lastCallArgs['getProperties'][0][0], equals('d1'));
      expect(lastCallArgs['getProperties'][0][1], equals('d2'));
      expect(lastCallArgs['getProperties'][0].length, equals(2));
      expect(props is Map<String, JoinProperties>, equals(true));
      expect(props['d1'] is JoinProperties, equals(true));
      expect(props['d1'].y, equals(50));
      expect(props['d2'].x, equals(100));
    });
  });

  group('getJoinProperties', () {
    test('should call getMultipleJoinProperties and reuturn a single JoinProperties object', () async {
      CF cf = new CF();
      JoinProperties props = await cf.getJoinProperties('d1');
      expect(lastCallArgs['getProperties'][0][0], equals('d1'));
      expect(lastCallArgs['getProperties'][0].length, equals(1));
      expect(props is JoinProperties, equals(true));
      expect(props.x, equals(0));
      expect(props.y, equals(50));
      expect(props.width, equals(320));
      expect(props.height, equals(100));
      expect(props.xRotation, equals(90));
      expect(props.yRotation, equals(180));
      expect(props.zRotation, equals(270));
      expect(props.scale, equals(1.1));
      expect(props.opacity, equals(0.5));
    });
  });

  group('setJoinProperties', () {
    test('should call setMultipleJoinProperties with one item', () {

    });
  });

  group('setMultipleJoinProperties', () {
    test('should call getProperties with the correct arguments', () async {

    });
  });
}