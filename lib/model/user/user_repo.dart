import 'dart:async';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:shared_preferences/shared_preferences.dart';

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
    String emotion = 'Happy';
    bool isFirstUser = prefs.getBool(StorageKeys.IS_FIRST_USER);
    bool isEmailVerified = prefs.getBool(StorageKeys.IS_EMAIL_VERIFIED);
    getEmotion().then((value) {
      emotion = value;
    });
    if (userId == null) {
      _auth.userChanges();
      firebase.User user = _auth.currentUser;
      if (user.uid == null) {
        return null;
      } else {
        User serializedUser = User(
            user.uid,
            user.displayName != null ? user.displayName : userName,
            user.photoURL,
            fcmToken,
            tenantId != null ? tenantId : user.tenantId,
            emotion: emotion,
            isFirstUser: isFirstUser,
            isEmailVerified: isEmailVerified);
        return serializedUser;
      }
    }
    return User(userId, userName, userImgUrl, fcmToken, tenantId,
        emotion: emotion,
        isFirstUser: isFirstUser,
        isEmailVerified: isEmailVerified);
  }

  void setCurrentUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = user.fcmToken.isEmpty
        ? prefs.getString(StorageKeys.FCM_TOKEN)
        : user.fcmToken;
    await prefs
        .setString(StorageKeys.USER_ID_KEY, user.uid)
        .then((val) => prefs.setString(StorageKeys.USER_NAME_KEY, user.name))
        .then((val) => prefs.setString(StorageKeys.USER_IMG_URL_KEY,
            user.imgURL != null ? user.imgURL : ''))
        .then((val) =>
            prefs.setString(StorageKeys.FCM_TOKEN, token != null ? token : ''))
        .then((val) => prefs.setString(
            StorageKeys.TENANT_ID, user.tenantId != null ? user.tenantId : ''))
        .then(
            (val) => prefs.setBool(StorageKeys.IS_FIRST_USER, user.isFirstUser))
        .then((val) =>
            prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, user.isEmailVerified));
  }

  void clearCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isFirstUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool(StorageKeys.IS_FIRST_USER);
    if (!result) {
      _auth.userChanges().forEach((user) {
        if (_auth.currentUser.uid == user.uid) {
          prefs.setBool(StorageKeys.IS_FIRST_USER,
              user.metadata.creationTime == user.metadata.lastSignInTime);
        }
      });
    }
    return prefs.getBool(StorageKeys.IS_FIRST_USER);
  }

  Future<bool> isEmailVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _auth.userChanges().forEach((user) {
      if (_auth.currentUser.uid == user.uid) {
        prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, user.emailVerified);
      }
    });

    return prefs.getBool(StorageKeys.IS_EMAIL_VERIFIED);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.USER_ID_KEY);
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
      if (documentSnapshot.data() != null) {
        if (documentSnapshot.get('emotion') != null &&
            documentSnapshot.get('emotion').isNotEmpty) {
          for (var value in documentSnapshot.get('emotion').last.values) {
            emotion = value;
            print("value: ${value}");
          }
        }
      }
    });
    return emotion;
  }

  void setBusinessWellbeing(String wellbeing, {update = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    if (update) {
      _firestore
          .collection(FirestorePaths.WELLBEING_COLLECTION)
          .doc(userId)
          .update({
        'business': {'wellbeing': wellbeing}
      });
    } else {
      _firestore
          .collection(FirestorePaths.WELLBEING_COLLECTION)
          .doc(userId)
          .set({
        'business': {'wellbeing': wellbeing}
      });
    }
  }

  void setSource(String source, {update = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    if (update) {
      _firestore
          .collection(FirestorePaths.WELLBEING_COLLECTION)
          .doc(userId)
          .update({'source': source});
    } else {
      _firestore
          .collection(FirestorePaths.WELLBEING_COLLECTION)
          .doc(userId)
          .set({'source': source});
    }
  }

  void setEmailVerified(bool isVerified) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, isVerified);
  }

  void setFirstUser(bool isFirstUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(StorageKeys.IS_FIRST_USER, isFirstUser);
  }

  void setEmotion(String emotion, {update = true}) async {
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
    if (update) {
      _firestore
          .collection(FirestorePaths.WELLBEING_COLLECTION)
          .doc(userId)
          .update({
        'emotion': FieldValue.arrayUnion([
          {now: emotion}
        ])
      });
    } else {
      _firestore
          .collection(FirestorePaths.WELLBEING_COLLECTION)
          .doc(userId)
          .set({
        'emotion': FieldValue.arrayUnion([
          {now: emotion}
        ])
      });
    }
    await prefs.setString(StorageKeys.EMOTION, emotion);
  }

  void setTenant(String tenantId, {update = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    if (update) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .update({'tenantId': tenantId});
    } else {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .set({'tenantId': tenantId});
    }
    await prefs.setString(StorageKeys.TENANT_ID, tenantId);
  }

  void setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.FCM_TOKEN, token);
  }
}
