import 'dart:async';
import 'dart:convert';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/util/constants.dart';
import 'package:chatapp/util/serialization_util.dart';
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
  List<User> _employees;

  void _initialize() async {
    _prefs = await SharedPreferences.getInstance();
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
    String business = _prefs.getString(StorageKeys.USER_BUSINESS);
    return User(userId, userName, userEmail, userImgUrl, fcmToken, tenantId,
        emotion: emotion,
        isFirstUser: isFirstUser,
        isEmailVerified: isEmailVerified,
        birthday: birthday,
        business: business);
  }

  Future<void> setCurrentUser(User firebaseUser) async {
    String id = firebaseUser.uid;
    _prefs.setString(StorageKeys.USER_ID_KEY, id);
    await _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data() != null) {
        if (documentSnapshot.get("name") != null) {
          _prefs.setString(
              StorageKeys.USER_NAME_KEY, documentSnapshot.get("name"));
        }
        if (documentSnapshot.get("imgURL") != null) {
          _prefs.setString(
              StorageKeys.USER_IMG_URL_KEY, documentSnapshot.get("imgURL"));
        }
        if (documentSnapshot.get("fcmToken") != null) {
          _prefs.setString(
              StorageKeys.FCM_TOKEN, documentSnapshot.get("fcmToken"));
        }
        if (documentSnapshot.get("email") != null) {
          _prefs.setString(
              StorageKeys.USER_EMAIL, documentSnapshot.get("email"));
        }
        if (documentSnapshot.get('emotion') != null) {
          _prefs.setString(
              StorageKeys.EMOTION, documentSnapshot.get('emotion'));
        }
        if (documentSnapshot.get("birthday") != null) {
          _prefs.setString(
              StorageKeys.USER_BIRTHDAY, documentSnapshot.get('birthday'));
        }
        if (documentSnapshot.get("isFirstUser") != null) {
          _prefs.setBool(
              StorageKeys.IS_FIRST_USER, documentSnapshot.get('isFirstUser'));
        }
        if (documentSnapshot.get("isEmailVerified") != null) {
          _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED,
              documentSnapshot.get('isEmailVerified'));
        }
        if (documentSnapshot.get("tenantId") != null) {
          _prefs.setString(
              StorageKeys.TENANT_ID, documentSnapshot.get("tenantId"));
        }
        if (documentSnapshot.get("business") != null) {
          _prefs.setString(
              StorageKeys.USER_BUSINESS, documentSnapshot.get("business"));
        }
      }
    });
  }

  List<String> getMyChallenges() {
    String id = _prefs.getString(StorageKeys.USER_ID_KEY);
    List<String> challenges = [];
    _firestore
        .collection(FirestorePaths.WELLBEING_COLLECTION)
        .doc(id)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.data() != null) {
        try {
          if (snapshot.get('area_of_life') != null) {
            challenges.add(snapshot.get('area_of_life'));
          }
          if (snapshot.get('coping_strategy') != null) {
            challenges.add(snapshot.get('coping_strategy'));
          }
          if (snapshot.get('unhealthy_thoughts') != null) {
            challenges.add(snapshot.get('unhealthy_thoughts'));
          }
        } catch (err) {
          print("field does not exist within the doc ${err.toString()}");
        }
      }
    });

    return challenges;
  }

  void fetchEmployees() {
    String currentUserName = _prefs.getString(StorageKeys.USER_NAME_KEY);
    String business = _prefs.getString(StorageKeys.USER_BUSINESS);
    print("print: ${business}");
    print('employee: ${currentUserName}');
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .orderBy("name")
        .snapshots()
        .map((data) => Deserializer.deserializeUsers(data.docs))
        .listen((users) {
      _employees = users;
      print("Employees: ${_employees.length}");
      List<User> employees = new List<User>.empty(growable: true);
      users.forEach((user) {
        if (user.name != currentUserName && user.business == business) {
          employees.add(user);
        }
      });
      List<String> stringifiedEmployees =
          new List<String>.empty(growable: true);
      employees.forEach((user) {
        stringifiedEmployees.add(json.encode(user.toJson()));
      });
      _prefs.setStringList(StorageKeys.EMPLOYEES, stringifiedEmployees);
    });
  }

  List<User> getEmployees() {
    List<User> employees = new List<User>.empty(growable: true);
    List<String> stringifiedEmployees =
        _prefs.getStringList(StorageKeys.EMPLOYEES);
    stringifiedEmployees.forEach((stringVal) {
      User user = new User.fromJson(json.decode(stringVal));
      employees.add(user);
    });
    return employees;
  }

  void setUpDatabase(id) {
    _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(id).set({
      'uid': id,
      'name': '',
      'email': '',
      'imgURL': '',
      'fcmToken': '',
      'tenantId': '',
      'isEmailVerified': false,
      'isFirstUser': true,
      'birthday': '',
      'emotion': '',
      'business': '',
    });
    _firestore
        .collection(FirestorePaths.WELLBEING_COLLECTION)
        .doc(id)
        .set({'source': null, 'emotion': null});
  }

  void clearCurrentUser() async {
    await _prefs.clear();
  }

  bool isFirstUser({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    bool isFirstUser = _prefs.getBool(StorageKeys.IS_FIRST_USER);
    if (isFirstUser == null) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          if (snapshot.get("isFirstUser") != null) {
            return snapshot.get('isFirstUser');
          }
        } else {
          return true;
        }
      });
    }
    return isFirstUser;
  }

  bool isEmailVerified({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    bool isEmailVerified = _prefs.getBool(StorageKeys.IS_EMAIL_VERIFIED);
    if (isEmailVerified == null) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          if (snapshot.get("isEmailVerified") != null) {
            isEmailVerified = snapshot.get('isEmailVerified');

            _prefs.setBool(StorageKeys.IS_EMAIL_VERIFIED, isEmailVerified);
            return isEmailVerified;
          }
        } else {
          return false;
        }
      });
    }
    return isEmailVerified;
  }

  String getBusiness({userId}) {
    if (userId == null) {
      userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    }
    String business = _prefs.getString(StorageKeys.USER_BUSINESS);
    if (business == null || business.isEmpty) {
      _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          if (snapshot.get("business") != null) {
            return snapshot.get('business');
          }
        }
        return "";
      });
    }
    return business;
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
        return "";
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
        return '';
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
        return 'Happy';
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

  void setBusiness(String business) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _prefs.setString(StorageKeys.USER_BUSINESS, business);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'business': business}, SetOptions(merge: true));
  }

  void setUserName(String name) {
    String userId = _prefs.getString(StorageKeys.USER_ID_KEY);
    _prefs.setString(StorageKeys.USER_NAME_KEY, name);
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .set({'name': name}, SetOptions(merge: true));
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
        .update({'isEmailVerified': isVerified});
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

  Stream<QuerySnapshot> getSnapshotsOfUsers() {
    return _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .orderBy("name")
        .snapshots();
  }

  Stream<QuerySnapshot> getSnapshotsOfWellbeingData() {
    return _firestore
        .collection(FirestorePaths.WELLBEING_COLLECTION)
        .snapshots();
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
