import 'dart:async';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  UserRepo() {
    _initialize();
  }
  static UserRepo _instance;
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static SharedPreferences _prefs;

  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  void _initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  User getCurrentUser() {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    String userName = _prefs.getString(StorageKeys.USER_NAME_KEY);
    String userImgUrl = _prefs.getString(StorageKeys.USER_IMG_URL_KEY);
    String fcmToken = _prefs.getString(StorageKeys.FCM_TOKEN);
    String tenantId = _prefs.getString(StorageKeys.TENANT_ID);
    String emotion = _prefs.getString(StorageKeys.EMOTION);
    String birthday = _prefs.getString(StorageKeys.USER_BIRTHDAY);
    bool isFirstUser = _prefs.getBool(StorageKeys.IS_FIRST_USER);
    bool isEmailVerified = _prefs.getBool(StorageKeys.IS_EMAIL_VERIFIED);
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
            isEmailVerified: isEmailVerified,
            birthday: birthday
        );
        return serializedUser;
      }
    }
    return User(userId, userName, userImgUrl, fcmToken, tenantId,
        emotion: emotion,
        isFirstUser: isFirstUser,
        isEmailVerified: isEmailVerified,
        birthday: birthday
    );
  }


  void setCurrentUser(User firebaseUser) {
    User user = getAdditionalUserDetails(firebaseUser);
      _prefs
          .setString(StorageKeys.USER_ID_KEY, user.uid)
          .then((val) => _prefs.setString(StorageKeys.USER_NAME_KEY, user.name != null ? user.name : ''))
          .then((val) => _prefs.setString(StorageKeys.USER_IMG_URL_KEY, user.imgURL != null ? user.imgURL : ''))
          .then((val) =>
          _prefs.setString(StorageKeys.FCM_TOKEN, user.fcmToken))
          .then((val) => _prefs.setString(
          StorageKeys.TENANT_ID, user.tenantId))
          .then((val) => _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, user.isEmailVerified))
          .then((val) => _prefs.setBool(StorageKeys.IS_FIRST_USER, user.isFirstUser))
          .then((val) => _prefs.setString(StorageKeys.USER_BIRTHDAY, user.birthday))
          .then((val) => _prefs.setString(StorageKeys.EMOTION, user.emotion));
  }

  void clearCurrentUser() async {
    await _prefs.clear();
  }

  bool isFirstUser({userId}) {
    if(userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    _auth.userChanges().forEach((user) {
      if (userId == user.uid) {
        _prefs.setBool(StorageKeys.IS_FIRST_USER, user.emailVerified);
      }
    });
    return _prefs.getBool(StorageKeys.IS_FIRST_USER);
  }

  bool isEmailVerified({userId}) {
    if(userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    _auth.userChanges().forEach((user) {
      if (userId == user.uid) {
        _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, user.emailVerified);
      }
    });

    return _prefs.getBool(StorageKeys.IS_EMAIL_VERIFIED);
  }

  String getUserName({userId}) {
    if(userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    String userName = _prefs.getString(StorageKeys.USER_NAME_KEY);
    if(userName == null || userName.isEmpty){
      _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(userId).get().then((DocumentSnapshot snapshot){
        if(snapshot.data() != null) {
          if(snapshot.get("name") != null) {
            return snapshot.get('name');
          }
        }
      });
    }
    return userName;
  }

  String getUserId() {
    return _prefs.getString(StorageKeys.USER_ID_KEY);
  }

  String getFCMToken() {
    return _prefs.getString(StorageKeys.FCM_TOKEN);
  }

  String getTenant({userId}) {
    if(userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    String tenant = _prefs.getString(StorageKeys.TENANT_ID);
    if(tenant == null || tenant.isEmpty){
      _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(userId).get().then((DocumentSnapshot snapshot){
        if(snapshot.data() != null) {
          if(snapshot.get("tenantId") != null) {
            return snapshot.get('tenantId');
          }
        }
      });
    }
    return tenant;
  }

  String getBirthday({userId}) {
    if(userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    String birthday = _prefs.getString(StorageKeys.USER_BIRTHDAY);
    if(birthday == null || birthday.isEmpty){
      _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(userId).get().then((DocumentSnapshot snapshot){
        if(snapshot.data() != null) {
          if(snapshot.get("birthday") != null) {
            return snapshot.get('birthday');
          }
        }
      });
    }
    return birthday;
  }

  String getEmotion({userId}) {
    if(userId == null)
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    String emotion = _prefs.getString(StorageKeys.EMOTION);
    if(emotion == null || emotion.isEmpty){
      _firestore
          .collection(FirestorePaths.WELLBEING_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.data() != null) {
          if (documentSnapshot.get('emotion') != null &&
              documentSnapshot.get('emotion').isNotEmpty) {
            print("latest: ${documentSnapshot.get('emotion').last}");
            emotion = documentSnapshot.get('emotion').last;
            _prefs.setString(StorageKeys.EMOTION, emotion);
            return emotion;
          }
        }
      });
    }
    return "Happy";
  }

  void setBusinessWellbeing(String wellbeing, {update = true}) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
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

  void setUserName(String name) {
    _prefs.setString(StorageKeys.USER_NAME_KEY, name);
  }

  User getAdditionalUserDetails(User user) {
    String emotion = getEmotion(userId: user.uid);
    String birthday = getBirthday(userId: user.uid);
    bool firstUser = isFirstUser(userId: user.uid);
    bool emailVerified = isEmailVerified(userId: user.uid);
    String id = user.uid;
    String tenant = user.tenantId;
    String userName = user.name;

    if(userName == null || userName.isEmpty){
      userName = getUserName(userId: user.uid);
    }
    if(tenant == null || tenant.isEmpty){
      tenant = getTenant(userId: user.uid);
    }
    return User(
        id,
        userName,
        user.imgURL,
        user.fcmToken,
        tenant,
        birthday: birthday,
        emotion: emotion,
        isFirstUser: firstUser,
        isEmailVerified: emailVerified
    );







  }

  void setBirthday(DateTime date, {update = true}) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    String dateToString = date.toString();
    if(update) {
      _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(userId).update({'birthday':dateToString});
    } else {
      _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(userId).set({'birthday':dateToString});
    }
    _prefs.setString(StorageKeys.USER_BIRTHDAY, dateToString);
  }

  void setSource(String source, {update = true}) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
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

  void setEmailVerified(bool isVerified) {
    _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, isVerified);
  }

  void setFirstUser(bool isFirstUser) {
    _prefs.setBool(StorageKeys.IS_FIRST_USER, isFirstUser);
  }

  void setEmotion(String emotion, {update = true}) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    var now = DateTime.now().toString();
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
    _prefs.setString(StorageKeys.EMOTION, emotion);
  }

  void setTenant(String tenantId, {update = true}) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
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
    _prefs.setString(StorageKeys.TENANT_ID, tenantId);
  }

  void setFCMToken(String token) {
    _prefs.setString(StorageKeys.FCM_TOKEN, token);
  }
}
