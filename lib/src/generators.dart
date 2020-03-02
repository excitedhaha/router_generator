import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';
import 'builder.dart';

const _paramChecker = TypeChecker.fromRuntime(RouterParam);

class Arg {
  final String type;
  final bool required;
  final String key;
  final String fieldName;

  Arg(this.type, this.required, this.key, this.fieldName);
}

class InjectGenerator extends GeneratorForAnnotation<Inject> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var className = element.name;
    ClassElement e = element as ClassElement;
    String pageName;

    // 验证类型，获取页面名
    if (isClassExtendsState(e)) {
      var typeArguments = e.supertype.typeArguments;
      if (typeArguments.isEmpty) {
        throw Exception('Injected State class must assign the Page Widget');
      }
      var pageElement = typeArguments[0].element;
      if (routerChecker.hasAnnotationOf(pageElement)) {
        var routerAnnotation = routerChecker.firstAnnotationOf(pageElement);
        pageName = routerAnnotation.getField('pageName').toStringValue();
      } else {
        throw Exception(
            'The widget class represents page should be annotated with Router');
      }
    } else {
      throw Exception('Injected class is not State');
    }

    var sourceName = e.source.shortName;
    var imports = <String>[];
    var args = <Arg>[];
    bool needConvert = false;
    String codes = '''
        import '$sourceName';
        import 'package:router_generator/router_generator.dart';
        void injectDependencies($className state){
          var map = paramsTable['$pageName'];
        ''';
    for (var fieldElement in e.fields) {
      if (_paramChecker.hasAnnotationOfExact(fieldElement)) {
        var fieldName = fieldElement.name;
        var paramAnnotation = _paramChecker.firstAnnotationOf(fieldElement);
        var keyField = paramAnnotation.getField('key').toStringValue();
        final key = keyField == null ? fieldName : keyField;
        final required = paramAnnotation.getField('required').toBoolValue();
        var fieldType = fieldElement.type;
        var value = "map['$key']";
        String statement;
        var ifStatement = '$value is $fieldType? $value :';
        if (fieldType.isDartCoreInt) {
          statement = "$ifStatement int.parse($value)";
        } else if (fieldType.isDartCoreDouble) {
          statement = "$ifStatement double.parse($value)";
        } else if (fieldType.isDartCoreBool) {
          statement = "$ifStatement $value == 'true'";
        } else if (fieldType.isDartCoreString) {
          statement = value;
        } else if (fieldType.isDartCoreMap || fieldType.isDartCoreList) {
          statement = '''$ifStatement jsonDecode($value)''';
          needConvert = true;
        } else {
          needConvert = true;
          imports.add(fieldElement.type.element.source.fullName);
          statement = '''
          $ifStatement ${fieldType.element.name}.fromJsonMap(jsonDecode($value))
          ''';
        }
        codes += '''
          if(map.containsKey('$key')){
            state.$fieldName = $statement;
          }
        ''';
        if (required) {
          codes += '''
          else{
            assert((){
              throw ArgumentNotFoundException('$fieldName','$className');
            }());
          }
          ''';
        }
        args.add(Arg(fieldType.toString(), required, key, fieldName));
      }
    }

    // 处理import
    if (needConvert) {
      codes = '''import 'dart:convert';
          ''' +
          codes;
    }
    for (var import in imports.toSet()) {
      codes = '''import '${import.split('/lib/')[1]}';
              ''' +
          codes;
    }
    codes += '''
    }
    ''';

    // 生成参数列表的方法
    var requiredArgs = args.where((arg) => arg.required);
    var requiredArgsStr =
        requiredArgs.map((arg) => '${arg.type} ${arg.fieldName}').join(',');
    var optionalArgs = args.where((arg) => !arg.required);
    var optionalArgsStr =
        optionalArgs.map((arg) => '${arg.type} ${arg.fieldName}').join(',');
    codes += '''
    Map<String, dynamic> createRouteArgs($requiredArgsStr${requiredArgsStr.isNotEmpty ? ',' : ''}{$optionalArgsStr}) {
      var args = <String, dynamic>{};
      ${requiredArgs.map((arg) => "args['${arg.key}']=${arg.fieldName};").join('\n')}
      ${optionalArgs.map((arg) => '''
    if(${arg.fieldName} != null){
      args['${arg.key}']=${arg.fieldName};
    }
    ''').join()}
      return args;
    }
    ''';
    return codes;
  }

  /// 类是否继承自State
  bool isClassExtendsState(ClassElement element) {
    var superType = element.supertype;
    while (superType != null) {
      element = superType.element;
      if (isStateClass(element)) {
        return true;
      } else {
        superType = element.supertype;
      }
    }
    return false;
  }

  bool isStateClass(ClassElement element) {
    return element.source.fullName ==
            '/flutter/lib/src/widgets/framework.dart' &&
        element.name == 'State';
  }
}

class RouterGenerator extends GeneratorForAnnotation<Router> {
  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var pageName = annotation.read('pageName').stringValue;
    var className = element.name;
    var import = "import '${element.source.fullName.split('/lib/')[1]}';";
    return '''
    $import
    var $pageName = '$className';
        ''';
  }
}
