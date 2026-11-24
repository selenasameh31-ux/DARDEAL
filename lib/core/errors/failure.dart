abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(super.message);
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class ConflictFailure extends Failure {
  ConflictFailure(super.message);
}

class TooManyRequestsFailure extends Failure {
  TooManyRequestsFailure(super.message);
}

class NoInternetFailure extends Failure {
  NoInternetFailure() : super("No Internet Connection");
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}
