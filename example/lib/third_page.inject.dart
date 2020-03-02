// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectGenerator
// **************************************************************************

import 'model.dart';
import 'dart:convert';
import 'third_page.dart';
import 'package:router_generator/router_generator.dart';

void injectDependencies(ThirdPageState state) {
  var map = paramsTable['third'];
  if (map.containsKey('person')) {
    state.person = map['person'] is Person
        ? map['person']
        : Person.fromJsonMap(jsonDecode(map['person']));
  } else {
    assert(() {
      throw ArgumentNotFoundException('person', 'ThirdPageState');
    }());
  }
  if (map.containsKey('set_key')) {
    state.setKey =
        map['set_key'] is bool ? map['set_key'] : map['set_key'] == 'true';
  }
  if (map.containsKey('map')) {
    state.map =
        map['map'] is Map<String, int> ? map['map'] : jsonDecode(map['map']);
  }
}

Map<String, dynamic> createRouteArgs(Person person,
    {bool setKey, Map<String, int> map}) {
  var args = <String, dynamic>{};
  args['person'] = person;
  if (setKey != null) {
    args['set_key'] = setKey;
  }
  if (map != null) {
    args['map'] = map;
  }

  return args;
}
