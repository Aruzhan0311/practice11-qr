abstract class AuthEvent {}

class AuthStartedEvent extends AuthEvent {}

class AuthLoggedInEvent extends AuthEvent {}

class AuthLoggedOutEvent extends AuthEvent {}
