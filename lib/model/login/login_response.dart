abstract class LoginResponse {}

class LoginFailedResponse extends LoginResponse {
  final String err;

  LoginFailedResponse(this.err);
}
