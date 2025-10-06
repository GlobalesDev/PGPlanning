enum SeccionParamType {
  GET,
  POST,
  FUNCTION,
}

extension ParseToString on String {
  SeccionParamType toSeccionParamType() {
    switch (this) {
      case 'get':
        return SeccionParamType.GET;
      case 'post':
        return SeccionParamType.POST;
      case 'function':
        return SeccionParamType.FUNCTION;
      default:
        return SeccionParamType.POST;
    }
  }
}