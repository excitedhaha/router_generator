import 'package:example/main.router_table.dart';
import 'package:example/model.dart';
import 'package:example/second_page.inject.dart';
import 'package:example/third_page.inject.dart' as third_page;
import 'package:flutter/material.dart';
import 'package:router_generator/router_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      onGenerateRoute: (RouteSettings settings) {
        String pageName = settings.name;
        var arguments = settings.arguments;
        if (arguments is Map<String, dynamic>) {
          deliverParams(pageName, arguments);
        }
        return MaterialPageRoute(builder: (_) {
          return getWidgetByPageName(pageName);
        });
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Router Generator'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Text(
                'second page',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('second',
                    arguments: createRouteArgs(name: 'bar'));
              },
            ),
            InkWell(
              child: Text('third page', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('third',
                    arguments: third_page.createRouteArgs(Person(23, 'kobe')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
