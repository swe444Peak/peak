import 'package:cloud_firestore/cloud_firestore.dart';

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

  

}