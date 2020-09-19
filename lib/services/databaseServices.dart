import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/firebaseAuthService.dart';
import 'package:peak/locator.dart';


class DatabaseServices {

  final FirbaseAuthService _firbaseAuthService = locator<FirbaseAuthService>();
  final String uid;
  DatabaseServices({this.uid});

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  
  Future updateUserData({String username}) async{

    return await userCollection.doc(uid).set({
      "username": username,
    });

  }//end updateUserData

  //creating user data stream to get user doc

  Stream<PeakUser> get userData {

    return userCollection.doc(_firbaseAuthService.currentUser.uid).snapshots()
    .map((event) => _userDataFromSnapshot(event));
  }

  //extract user data from snapshot 

  PeakUser _userDataFromSnapshot(DocumentSnapshot snapshot){
    return PeakUser(
      uid: _firbaseAuthService.currentUser.uid,
      name: snapshot.data()['username'],
      );
  }

}