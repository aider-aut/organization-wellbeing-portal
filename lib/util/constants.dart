class ErrMessages {
  static const String NO_USER_FOUND = "Login Failure: No user has been found";
}

class StorageKeys {
  static const String USER_ID_KEY = "user_id_key";
  static const String USER_NAME_KEY = "user_name_key";
  static const String USER_IMG_URL_KEY = "user_img_url_key";
  static const String FCM_TOKEN = "fcmToken";
}

class UIConstants {
  //FONT SIZE
  static const double SMALL_FONT = 10.0;
  static const double NORMAL_FONT = 14.0;
  static const double LARGE_FONT = 18.0;

  // PADDING
  static const double SMALL_PADDING = 8.0;
  static const double NORMAL_PADDING = 16.0;
  static const double LARGE_PADDING = 24.0;

  // ELEVATION
  static const double NORMAL_ELEVATION = 3.0;
}

class FirestorePaths {
  static const String ROOT_PATH = "";
  static const String USERS_COLLECTION = ROOT_PATH + 'users';
  static const String CHATROOMS_COLLECTION = ROOT_PATH + 'chatrooms';
  static const String USER_DOCUMENT = USERS_COLLECTION + '/{user_id}';
}
