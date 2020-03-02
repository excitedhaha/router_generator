import 'package:example/second_page.inject.dart';
import 'package:flutter/material.dart';
import 'package:router_generator/core.dart';

@Router('second')
class SecondPage extends StatefulWidget {
  @override
  SecondPageState createState() => SecondPageState();
}

@inject
class SecondPageState extends State<SecondPage> {
  @routerParam
  String name = 'foo';
  @routerParam
  int count = 666;

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
          title: Text('Second Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text(name), Text(count.toString())],
          ),
        ));
  }
}
