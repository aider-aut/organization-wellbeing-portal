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

  // UserRepo._internal();

  // factory UserRepo() {
  //   if (_instance == null) {
  //     _instance = UserRepo._internal();
  //   }
  //   return _instance;
  // }

  void _initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void fetchCurrentUser(userId) {
    if (userId == null) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((value) => {
                value.data().forEach((key, value) {
                  if (value is bool) {
                    if (key == "isEmailVerified") {
                      _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, value);
                    } else if (key == 'isFirstUser') {
                      _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, value);
                    }
                  } else if (value is String) {
                    switch (key) {
                      case 'name':
                        {
                          _prefs.setString(StorageKeys.USER_NAME_KEY, value);
                        }
                        break;

                      case 'email':
                        {
                          _prefs.setString(StorageKeys.USER_EMAIL, value);
                        }
                        break;

                      case 'emotion':
                        {
                          _prefs.setString(StorageKeys.EMOTION, value);
                        }
                        break;

                      case 'fcmToken':
                        {
                          _prefs.setString(StorageKeys.FCM_TOKEN, value);
                        }
                        break;

                      case 'tenantId':
                        {
                          _prefs.setString(StorageKeys.TENANT_ID, value);
                        }
                        break;

                      case 'imgURL':
                        {
                          _prefs.setString(StorageKeys.USER_IMG_URL_KEY, value);
                        }
                        break;
                    }
                  }
                })
              });
    }
  }

  User getCurrentUser() {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    String userName = _prefs.getString(StorageKeys.USER_NAME_KEY);
    String userEmail = _prefs.getString(StorageKeys.USER_EMAIL);
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
            user.email,
            user.photoURL,
            fcmToken,
            tenantId != null ? tenantId : user.tenantId,
            emotion: emotion,
            isFirstUser: isFirstUser,
            isEmailVerified: isEmailVerified,
            birthday: birthday);
        return serializedUser;
      }
    }
    return User(userId, userName, userEmail, userImgUrl, fcmToken, tenantId,
        emotion: emotion,
        isFirstUser: isFirstUser,
        isEmailVerified: isEmailVerified,
        birthday: birthday);
  }

  void setCurrentUser(User firebaseUser) {
    User user = getAdditionalUserDetails(firebaseUser);
    _prefs.setString(StorageKeys.USER_ID_KEY, user.uid);
    if (user.name != null) {
      _prefs.setString(StorageKeys.USER_NAME_KEY, user.name);
    }
    if (user.email != null) {
      _prefs.setString(StorageKeys.USER_EMAIL, user.email);
    }
    if (user.imgURL != null) {
      _prefs.setString(StorageKeys.USER_IMG_URL_KEY, user.imgURL);
    }
    if (user.fcmToken != null) {
      _prefs.setString(StorageKeys.FCM_TOKEN, user.fcmToken);
    }
    if (user.tenantId != null) {
      _prefs.setString(StorageKeys.TENANT_ID, user.tenantId);
    }
    if (user.isEmailVerified != null) {
      _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, user.isEmailVerified);
    }
    if (user.isFirstUser != null) {
      _prefs.setBool(StorageKeys.IS_FIRST_USER, user.isFirstUser);
    }
    if (user.birthday != null) {
      _prefs.setString(StorageKeys.USER_BIRTHDAY, user.birthday);
    }
    if (user.emotion != null) {
      _prefs.setString(StorageKeys.EMOTION, user.emotion);
    }
  }

  void setUpDatabase(UserId) {
    _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(UserId).set({
      'name': '',
      'email': '',
      'imgURL': '',
      'fcmToken': '',
      'tenantId': '',
      'isEmailVerified': false,
      'isFirstUser': true,
      'birthday': '',
      'emotion': '',
    });
    _firestore
        .collection(FirestorePaths.WELLBEING_COLLECTION)
        .doc(UserId)
        .set({'source': null, 'business': null, 'emotion': null});
  }

  void clearCurrentUser() async {
    await _prefs.clear();
  }

  bool isFirstUser({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    return _prefs.getBool(StorageKeys.IS_FIRST_USER);
  }

  bool isEmailVerified({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    return _prefs.getBool(StorageKeys.IS_EMAIL_VERIFIED);
  }

  String getUserName({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    String userName = _prefs.getString(StorageKeys.USER_NAME_KEY);
    if (userName == null || userName.isEmpty) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          if (snapshot.get("name") != null) {
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

  String getEmail() {
    return _prefs.getString(StorageKeys.USER_EMAIL);
  }

  String getTenant({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    String tenant = _prefs.getString(StorageKeys.TENANT_ID);
    if (tenant == null || tenant.isEmpty) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          if (snapshot.get("tenantId") != null) {
            return snapshot.get('tenantId');
          }
        }
      });
      return "Employer";
    }
    return tenant;
  }

  String getBirthday({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    String birthday = _prefs.getString(StorageKeys.USER_BIRTHDAY);
    if (birthday == null || birthday.isEmpty) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          if (snapshot.get("birthday") != null) {
            return snapshot.get('birthday');
          }
        }
      });
    }
    return birthday;
  }

  String getEmotion({userId}) {
    if (userId == null) userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    String emotion = _prefs.getString(StorageKeys.EMOTION);
    if (emotion == null || emotion.isEmpty) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.data() != null) {
          if (documentSnapshot.get('emotion') != null &&
              documentSnapshot.get('emotion').isNotEmpty) {
            print("latest: ${documentSnapshot.get('emotion')}");
            emotion = documentSnapshot.get('emotion');
            _prefs.setString(StorageKeys.EMOTION, emotion);
            return emotion;
          }
        }
      });
    }
    return emotion;
  }

  void setBusinessWellbeing(String wellbeing) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore.collection(FirestorePaths.WELLBEING_COLLECTION).doc(userId).set({
      'business': {'wellbeing': wellbeing}
    }, SetOptions(merge: true));
  }

  void setUserName(String name) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _prefs.setString(StorageKeys.USER_NAME_KEY, name);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'name': name}, SetOptions(merge: true));
  }

  User getAdditionalUserDetails(User user) {
    String emotion = getEmotion(userId: user.uid);
    String birthday = getBirthday(userId: user.uid);
    bool firstUser = isFirstUser(userId: user.uid);
    bool emailVerified = isEmailVerified(userId: user.uid);
    String id = user.uid;
    String tenant = user.tenantId;
    String userName = user.name;

    if (userName == null || userName.isEmpty) {
      userName = getUserName(userId: user.uid);
    }
    if (tenant == null || tenant.isEmpty) {
      tenant = getTenant(userId: user.uid);
    }
    return User(id, userName, user.email, user.imgURL, user.fcmToken, tenant,
        birthday: birthday,
        emotion: emotion,
        isFirstUser: firstUser,
        isEmailVerified: emailVerified);
  }

  void setUserId(String uid) {
    _prefs.setString(StorageKeys.USER_ID_KEY, uid);
  }

  void sendPasswordReset() {
    _auth
        .sendPasswordResetEmail(email: getEmail())
        .then((value) => {print("reset email has been sent")})
        .catchError((err) => {
              print(
                  "error occured in sending password-reset email: ${err.toString()}")
            });
  }

  void setBirthday(String date) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'birthday': date}, SetOptions(merge: true));
    _prefs.setString(StorageKeys.USER_BIRTHDAY, date);
  }

  void setEmail(String email) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'email': email}, SetOptions(merge: true));
    _prefs.setString(StorageKeys.USER_EMAIL, email);
  }

  void setSource(String source) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore
        .collection(FirestorePaths.WELLBEING_COLLECTION)
        .doc(userId)
        .set({'source': source}, SetOptions(merge: true));
  }

  void setEmailVerified(bool isVerified) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'isEmailVerified': isVerified}, SetOptions(merge: true));
    _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, isVerified);
  }

  void setFirstUser(bool isFirstUser) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'isFirstUser': isFirstUser}, SetOptions(merge: true));
    _prefs.setBool(StorageKeys.IS_FIRST_USER, isFirstUser);
  }

  void setEmotion(String emotion) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    var now = DateTime.now().toString();
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'emotion': emotion}, SetOptions(merge: true));
    _firestore.collection(FirestorePaths.WELLBEING_COLLECTION).doc(userId).set({
      'emotion': FieldValue.arrayUnion([
        {now: emotion}
      ])
    }, SetOptions(merge: true));
    _prefs.setString(StorageKeys.EMOTION, emotion);
  }

  void setTenant(String tenantId) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'tenantId': tenantId}, SetOptions(merge: true));
    _prefs.setString(StorageKeys.TENANT_ID, tenantId);
  }

  void setFCMToken(String token) {
    _prefs.setString(StorageKeys.FCM_TOKEN, token);
  }
}
