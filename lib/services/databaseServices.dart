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
      //add goals !!
    });

  }//end updateUserData

  //creating user data stream to get user doc

  Stream<PeakUser> userData(String id) {

    return userCollection.doc(id).snapshots()
    .map((event) => _userDataFromSnapshot(event));
  }

  //extract user data from snapshot 

  PeakUser _userDataFromSnapshot(DocumentSnapshot snapshot){
    return PeakUser(
      uid: snapshot.id,
      name: snapshot.data()['username'],
      );
  }

  

}