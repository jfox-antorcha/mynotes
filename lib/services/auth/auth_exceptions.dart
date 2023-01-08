// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongCredentialsAuthException implements Exception {}

// register exceptions

class WeekPasswordAuthException implements Exception {}

class EmailAlredyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
