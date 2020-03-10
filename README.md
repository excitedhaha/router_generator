# router_generator is a flutter library for router generation.[中文文档](https://github.com/excitedhaha/router_generator/blob/master/README_CN.md)
[![pub package](https://img.shields.io/pub/v/router_generator.svg)](https://pub.dartlang.org/packages/router_generator)
### install
```
dev_dependencies:
 router_generator: ^0.1.2
 build_runner:
```
### import
`import 'package:router_generator/router_generator.dart';`
### mark page
```
@Router('third')
class ThirdPage extends StatefulWidget {
```
Mark the page widget with `Router` annotation，provide the page name as key.
### mark argumengs
```
@inject
class ThirdPageState extends State<ThirdPage> {
 @RouterParam(required: true)
 Person person;
 @RouterParam(key: 'set_key')
 bool setKey = false;
 @routerParam
 Map<String, int> map;
```
Annotated the state needs dependencies with `inject`.Add arguments in state directly, and annotated them with `RouterParam`。
`RouterParam `has two args:
- key: The key of the param, use the field name instead if not provided
- required：If true, the arguments from route must contains this param
If neither params needed，use`routerParam` is recommended.
From the example above，**every types in dart are supported, including custom type**。
### code generation
This library builds on top of source_gen, so you can run the command:`flutter packages pub run build_runner build`, refer to [build_runner](https://pub.dev/packages/build_runner) for more detail.
Generated dart files including：
- A `$root_file.router_table.dart`, has a list of page names and a method for creating widget by page name，root_file is the router table file's prefix.
- several `$page.inject.dart`，the `page` is your file that contains the marked state， like `foo.dart` to `foo.inject.dart`
`main.dart` is the default root file of `router_table`file, it can be configured in `build.yaml`:
```
targets:
 $default:
 builders:
 router_generator|router_combining:
 options:
 router_table_root_file: "router.dart" # modify this value 
```
### Use it 
#### GenerateRoute
```
MaterialApp(
  ...
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
```
In the `onGenerateRoute `, call `$root_file.router_table.dart`'s `getWidgetByPageName`，get the page widget，and use `deliverParams() `to deliver params.
For the embedding App：
```
onGenerateRoute: (RouteSettings settings) {
    String route = settings.name;
    Uri uri = Uri.parse(route);
    var pageName = uri.path.replaceFirst(RegExp('/'), '');
    lastRouteParams = uri.queryParameters;
    return PageRouteBuilder(pageBuilder: (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return getWidgetByPageName(pageName);
    });
  },
```
The params in URI, Map<String, String> is supported, no needs for extra transform.
#### dependency injection
In the state needs dependencies, import the corresponding inject file, and inject before use them：
```
@override
void initState() {
 super.initState();
 injectDependencies(this);
 doSometing();
}
```
#### pass argumens
```
Navigator.of(context).pushNamed('second',
 arguments: {'name': 'bar', 'count': 666});
 
```
You can create the arguments by hand，but the method in inject file is better
```
Navigator.of(context).pushNamed('second',
 arguments: createRouteArgs(name: 'bar', count: 666));
```