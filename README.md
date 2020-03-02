# router_generator
### router_generator 是用于flutter路由的页面表及页面参数绑定自动生成框架
### 安装
```
dev_dependencies:
  router_generator: 0.1.1
  build_runner:
```

### 引用
`import 'package:router_generator/router_generator.dart';`
### 页面标记

```
@Router('third')
class ThirdPage extends StatefulWidget {
```
在页面Widget上使用Router注解，页面名作为参数

### 参数标记
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

给需要注入依赖的State添加`inject`注解，并且在变量上添加`RouterParam 注解`。
`RouterParam `有两个可选的参数:

- key: 此参数在参数表中的键，默认用变量名
- required：是否必须，如果是的话，在依赖注入时，如果参数表中没有此参数，debug模式下会报错，并且在生成的`createRouteArgs`方法中此参数为必须。

如果两个参数都不需要，建议用`routerParam`注解。
从例子中可以看到，**dart的各种类型包括自定义的model都是支持的**。

### 代码生成
执行命令:`flutter packages pub run build_runner build`, 更多使用方法可参考 [build_runner](https://pub.dev/packages/build_runner)

生成的若干dart文件中包含：

- 页面路由表 `main.router_table.dart`
- 页面依赖注入 `$page.inject.dart` 若干个，其中 page 是你 state所在 文件的名称，例如 `foo.dart`对应`foo.inject.dart`

### 引用
#### 路由生成
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

修改`onGenerateRoute `方法，调用`main.router_table.dart`中的`getWidgetByPageName`，获取对应的页面Widget，并且`deliverParams() `传递参数。

对于嵌入原有原生的App，可参考：

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
Map<String, String>类型的参数表（即uri中值为字符串的参数表）也是支持的，不需要额外转换。


#### 依赖注入

在已注入依赖的state中import 对应的inject文件，在使用变量前注入依赖，如：

```
@override
void initState() {
	super.initState();
	injectDependencies(this);
	doSometing();
}
```

#### 传递依赖
```

Navigator.of(context).pushNamed('second',
                    arguments: {'name': 'bar', 'count': 666});
                    
```
可以手动创建依赖的参数表，但建议使用 inject 文件中的 `createRouteArgs`方法。

```
Navigator.of(context).pushNamed('second',
                    arguments: createRouteArgs(name: 'bar', count: 666));

```