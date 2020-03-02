class ArgumentNotFoundException implements Exception {
  final argumentName;
  final stateName;

  const ArgumentNotFoundException(this.argumentName, this.stateName);

  @override
  String toString() {
    return 'Required argument not found, state name:$stateName, argument name:$argumentName.';
  }
}
