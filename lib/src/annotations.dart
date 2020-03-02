class Router {
  /// The name of the page
  final String pageName;

  const Router(this.pageName);
}

class RouterParam {
  /// The key of the param, use the field name instead if not provided
  final String key;
  /// Is this param required
  final bool required;

  const RouterParam({this.key, this.required = false});
}

const routerParam = const RouterParam();

const inject = const Inject._();

class Inject {
  const Inject._();
}
