import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';
import 'generators.dart';

const ROUTER_EXTENSION = '.router';
const _OUTPUT_EXTENSIONS = '.router_table.dart';

const pageRegExpLiteral = r'[A-Za-z_\d-]+';

Builder injectBuilder(BuilderOptions options) =>
    LibraryBuilder(InjectGenerator(), generatedExtension: '.inject.dart');

Builder routerBuilder(BuilderOptions options) {
  return LibraryBuilder(RouterGenerator(),
      generatedExtension: ROUTER_EXTENSION);
}

const routerChecker = TypeChecker.fromRuntime(Router);

Builder routerCombiningBuilder(BuilderOptions options) {
  print(options.config['router_table_root_file']);
  return options.config.containsKey('router_table_root_file')
      ? RouterCombiningBuilder(
          router_table_root_file: options.config['router_table_root_file'])
      : RouterCombiningBuilder();
}

class RouterCombiningBuilder implements Builder {
  final String router_table_root_file;

  const RouterCombiningBuilder({this.router_table_root_file = 'main.dart'});

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': [_OUTPUT_EXTENSIONS],
      };

  @override
  Future build(BuildStep buildStep) async {
    if (!buildStep.inputId.path.endsWith(router_table_root_file)) return;
    var pageNames = <String>[];
    final pattern = 'lib/**$ROUTER_EXTENSION';
    final assetIds = await buildStep.findAssets(Glob(pattern)).toList()
      ..sort();

    var imports = [];
    var cases = [];
    for (var id in assetIds) {
      var content = (await buildStep.readAsString(id)).trim();
      var lines = content.split('\n');
      imports.add(lines[6]);
      var statement = lines[8];
      var pageName = statement.split('var ')[1].split(' =')[0];
      pageNames.add('"$pageName"');
      var className = statement.split("= '")[1].split("'")[0];

      var switchCase = '''
  case '$pageName':
      {
        return $className();
      }
      ''';
      cases.add(switchCase);
    }

    final output = '''
$defaultFileHeader
import 'package:flutter/widgets.dart';
${imports.join('\n')}

const PAGE_NAMES = $pageNames;

Widget getWidgetByPageName(String pageName) {
  switch (pageName) {
  ${cases.join()}
  }
  return null;
}
''';
    await buildStep.writeAsString(
        buildStep.inputId.changeExtension(_OUTPUT_EXTENSIONS), output);
  }
}
