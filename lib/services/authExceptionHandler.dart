enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  weakPassword,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  undefined,
  tooManyRequests,
  networkRequestFailed,
  usernameAlreadyExists,
}

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "too-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "network-request-failed":
        status = AuthResultStatus.networkRequestFailed;
        break;
      case "permission-denied":
        status = AuthResultStatus.usernameAlreadyExists;
        break;

      default:
        status = AuthResultStatus.undefined;
    }
    return generateExceptionMessage(status);
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.weakPassword:
        errorMessage = "password must be at least 6 characters long";
        break;
      case AuthResultStatus.invalidEmail:
        errorMessage = "Invalid email address";
        break;
      case AuthResultStatus.userNotFound:
      case AuthResultStatus.wrongPassword:
        errorMessage = "Wrong email or password";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = "The email has already been registered";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later";
        break;
      case AuthResultStatus.networkRequestFailed:
        errorMessage =
            "Unable to connect please check your internet connection";
        break;
      case AuthResultStatus.usernameAlreadyExists:
        errorMessage =
            "Username Already Exists";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}
