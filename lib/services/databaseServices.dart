import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/models/user.dart';
class DatabaseServices {

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

  Stream<User> get userData{
    print("inside userData uid = ${uid}");
    return userCollection.doc(uid).snapshots()
    .map((event) => _userDataFromSnapshot(event));
  }

  //extract user data from snapshot 

  User _userDataFromSnapshot(DocumentSnapshot snapshot){
    print("inside _userDataFromSnapshot uid = ${uid}, name = ${snapshot.data()['username']}");
    return User(
      uid: uid,
      name: snapshot.data()['username'],
      );
  }

}