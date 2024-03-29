import 'package:get_it/get_it.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/dialogService.dart';
import 'package:peak/services/firebaseAuthService.dart';
import 'package:peak/services/googleCalendar.dart';
import 'package:peak/viewmodels/SearchForFriendModel.dart';
import 'package:peak/viewmodels/addCompetitors_model.dart';
import 'package:peak/viewmodels/commentsList_model.dart';
import 'package:peak/viewmodels/competitorsProgress_model.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:peak/viewmodels/editGoal_model.dart';
import 'package:peak/viewmodels/editProfile_model.dart';
import 'package:peak/viewmodels/friendsList_model.dart';
import 'package:peak/viewmodels/goalDetails_model.dart';
import 'package:peak/viewmodels/goalsList_model.dart';
import 'package:peak/viewmodels/home_model.dart';
import 'package:peak/viewmodels/login_model.dart';
import 'package:peak/viewmodels/receivedInvitations_model.dart';
import 'package:peak/viewmodels/sentInvitations_model.dart';
import 'package:peak/viewmodels/signup_model.dart';
import 'package:peak/viewmodels/viewBadges_model.dart';
import 'package:peak/viewmodels/viewProgress_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirbaseAuthService());
  locator.registerLazySingleton(() => GoogleCalendar());
  locator.registerLazySingleton(() => DatabaseServices());
  locator.registerLazySingleton(() => DialogService());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => SignUpModel());
  locator.registerFactory(() => GoalsListModel());
  locator.registerFactory(() => CreateGoalModel());
  locator.registerFactory(() => GoalDetailsModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => EditGoalModel());
  locator.registerFactory(() => EditProfileModel());
  locator.registerFactory(() => ViewProgressModel());
  locator.registerFactory(() => ViewBadgesModel());
  locator.registerFactory(() => FriendsListModel());
  locator.registerFactory(() => SearchForFriendModel());
  locator.registerFactory(() => SentInvitationsModel());
  locator.registerFactory(() => ReceivedInvitationsModel());
  locator.registerFactory(() => AddCompetitorsModel());
  locator.registerFactory(() => CommentsListModel());
  locator.registerFactory(() => CompetitorsProgressModel());
}
