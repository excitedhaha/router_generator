class Router {
  /// The name of the page
  final String pageName;

  const Router(this.pageName);
}

class RouterParam {
  /// The key of the param, use the field name instead if not provided
  final String key;

  /// If true, the arguments from route must contains this param
  final bool required;

  const RouterParam({this.key, this.required = false});
}

/// annotate param field with this when use field'name as key and not required
const routerParam = const RouterParam();

/// The state needs to inject dependencies should annotates with [inject]
const inject = const Inject._();

class Inject {
  const Inject._();
}
