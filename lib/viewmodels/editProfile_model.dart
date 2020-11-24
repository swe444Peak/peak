import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/UsernameExistsException.dart';
import 'package:peak/services/authExceptionHandler.dart';
import 'package:peak/services/databaseServices.dart';

class EditProfileModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  final ImagePicker _picker = ImagePicker();
  ValidationItem _name = ValidationItem(null, null);

  ValidationItem get name => _name;
  bool get isValid => name.value != null;
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  isexist(name) async {
    bool exist = await _firstoreService.usernameExist(name);
    if (exist) {
      return true;
    }
    return false;
  }

  void setName(String name) {
    if (name.trim().isEmpty) {
      _name = ValidationItem(null, "please enter your name");
    } else if (!validateUserName(name)) {
      name.length < 4 || name.length > 16
          ? _name =
              ValidationItem(null, "username must be 4-16 characters long")
          : _name =
              ValidationItem(null, "username contain an unvalid character");
    } else {
      _name = ValidationItem(name, null);
    }
    notifyListeners();
  }

  bool validateUserName(String username) {
    Pattern pattern = r'^[-\w\.\$@\*\!]{4,16}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(username))
      return false;
    else
      return true;
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

  Future update(File _myImage, username) async {
    if (_myImage != null) {
      setState(ViewState.Busy);
      Random rand = Random();
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(
              'profilepics/${rand.nextInt(50000).toString()}.jpg'); //i is the name of the image

      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_myImage);
      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();
      if (uploadTask.isComplete) {
        final String url = downloadUrl.toString();
        _firstoreService.updateProfilePic(url, username);
        print(url);
        //You might want to set this as the _auth.currentUser().photourl
      } else {
        //error uploading
      }
      setState(ViewState.Idle);
    }
  }
}
