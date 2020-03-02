Map<String, Map<String, dynamic>> paramsTable = Map();

/// deliver new page's [params], previous params for the same [pageName] will be overridden
/// [params] should be key-values
void deliverParams(String pageName, Map<String, dynamic> params) {
  paramsTable[pageName] = params;
}
