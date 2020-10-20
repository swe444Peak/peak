import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/databaseServices.dart';

class EditProfileModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  final ImagePicker _picker = ImagePicker();
  ValidationItem _name = ValidationItem(null, null);

  ValidationItem get name => _name;

  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setName(String name) {
    if (name.trim().isEmpty) {
      _name = ValidationItem(null, "name field is required");
    } else {
      _name = ValidationItem(name, null);
    }
    notifyListeners();
  }

  Future updateName(newName) async {
    print("in updateee");
    print(_name.toString());
    var wait = await _firstoreService.updateAccountData(newName);
  }

  Future pickImage() async {
    var image = await _picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 1500,
      maxWidth: 1500,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future uploadPic() async {
    final File _myImage = await pickImage();
    if (_myImage != null) {
      print('IN UPLOAD');
      var rand = Random(25);
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(
              'profilepics/${rand.nextInt(5000).toString()}.jpg'); //i is the name of the image
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_myImage);
      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();
      if (uploadTask.isComplete) {
        final String url = downloadUrl.toString();
        _firstoreService.updateProfilePic(url);
        print(url);
        //You might want to set this as the _auth.currentUser().photourl
      } else {
        //error uploading
      }
    }
    print('PROBLEM IN PICK');
  }
}