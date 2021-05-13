import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserRepo {
  static UserRepo _instance;
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    String userName = prefs.getString(StorageKeys.USER_NAME_KEY);
    String userImgUrl = prefs.getString(StorageKeys.USER_IMG_URL_KEY);
    String fcmToken = prefs.getString(StorageKeys.FCM_TOKEN);
    String tenantId = prefs.getString(StorageKeys.TENANT_ID);
    if(userId == null) {
      firebase.User user = _auth.currentUser;
      if(user.uid == null) {
        return null;
      } else {
        User serializedUser = User(
            user.uid,
            user.displayName != null ? user.displayName : userName,
            user.photoURL,
            fcmToken,
            user.tenantId
        );
        return serializedUser;
      }
    }
    return User(userId, userName, userImgUrl, fcmToken, tenantId);
  }

  void setCurrentUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = user.fcmToken.isEmpty
        ? prefs.getString(StorageKeys.FCM_TOKEN)
        : user.fcmToken;
    await prefs
        .setString(StorageKeys.USER_ID_KEY, user.uid)
        .then((val) => prefs.setString(StorageKeys.USER_NAME_KEY, user.name))
        .then(
            (val) => prefs.setString(StorageKeys.USER_IMG_URL_KEY, user.imgURL))
        .then((val) => prefs.setString(StorageKeys.FCM_TOKEN, token))
        .then((val) => prefs.setString(StorageKeys.TENANT_ID, user.tenantId));
  }

  void clearCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.FCM_TOKEN);
  }

  Future<String> getTenant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.TENANT_ID);
  }

  Future<String> getEmotion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    String emotion = 'Happy';
    _firestore
        .collection(FirestorePaths.WELLBEING_COLLECTION)
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.data() != null && documentSnapshot.data().containsKey('emotion')) {
            if(documentSnapshot.data()['emotion'] != null && documentSnapshot.data()['emotion'].isNotEmpty){
              for(var value in documentSnapshot.data()['emotion'].last.values) emotion = value;

            }
          }
    });
    return emotion;

  }

  void setEmotion(String emotion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    var now = DateTime.now().toString();
    // _firestore
    //     .collection(FirestorePaths.WELLBEING_COLLECTION)
    //     .doc(userId)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //       print(documentSnapshot.data());
    //
    //   if (documentSnapshot.data().containsKey('emotion')) {
    //     if(documentSnapshot.data()['emotion'].isEmpty){
    //       _firestore.collection(FirestorePaths.WELLBEING_COLLECTION).doc(userId).set({
    //         'emotion': []
    //       });
    //     }
    //   }
    // });
    _firestore.collection(FirestorePaths.WELLBEING_COLLECTION).doc(userId).set({
      'emotion': FieldValue.arrayUnion([{now: emotion}])
    });
    await prefs.setString(StorageKeys.EMOTION, emotion);
  }

  void setTenant(String tenantId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(userId).set({
        'tenantId': tenantId
    });
    await prefs.setString(StorageKeys.TENANT_ID, tenantId);
  }

  void setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.FCM_TOKEN, token);
  }
}
