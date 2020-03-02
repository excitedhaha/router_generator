import 'package:example/third_page.inject.dart';
import 'package:flutter/material.dart';
import 'package:router_generator/core.dart';

import 'model.dart';

@Router('third')
class ThirdPage extends StatefulWidget {
  @override
  ThirdPageState createState() => ThirdPageState();
}

@inject
class ThirdPageState extends State<ThirdPage> {
  @RouterParam(required: true)
  Person person;
  @RouterParam(key: 'set_key')
  bool setKey = false;
  @routerParam
  Map<String, int> map;

  @override
  void initState() {
    super.initState();
    injectDependencies(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Third Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('person:${person.name} ${person.id}'),
              Text('key:$setKey')
            ],
          ),
        ));
  }
}
