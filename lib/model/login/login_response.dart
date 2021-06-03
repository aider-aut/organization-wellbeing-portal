abstract class LoginResponse {}

class LoginFailedResponse extends LoginResponse {
  final String err;

  LoginFailedResponse(this.err);
}

class LoginSuccessResponse extends LoginResponse {
  final String message;

  LoginSuccessResponse(this.message);
}
