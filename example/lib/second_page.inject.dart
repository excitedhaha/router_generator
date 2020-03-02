// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectGenerator
// **************************************************************************

import 'second_page.dart';
import 'package:router_generator/core.dart';

void injectDependencies(SecondPageState state) {
  var map = paramsTable['second'];
  if (map.containsKey('name')) {
    state.name = map['name'];
  }
  if (map.containsKey('count')) {
    state.count = map['count'] is int ? map['count'] : int.parse(map['count']);
  }
}

Map<String, dynamic> createRouteArgs({String name, int count}) {
  var args = <String, dynamic>{};

  if (name != null) {
    args['name'] = name;
  }
  if (count != null) {
    args['count'] = count;
  }

  return args;
}
