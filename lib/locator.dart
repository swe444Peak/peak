import 'package:get_it/get_it.dart';
import 'package:peak/services/firebaseAuthService.dart';
import 'package:peak/viewmodels/login_model.dart';
import 'package:peak/viewmodels/signup_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirbaseAuthService());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => SignUpMaodel());
}
