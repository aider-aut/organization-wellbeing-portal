import 'package:flutter/material.dart';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/util/constants.dart';

class UserItem extends StatelessWidget {
  UserItem({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.symmetric(
              horizontal: 0, vertical: UIConstants.SMALL_PADDING),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48.0),
            child: user.imgURL != null ? Image.network(
              user.imgURL,
              height: 96,
              width: 96,
            ) : null,
          )),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(UIConstants.SMALL_PADDING),
          child: Text(
            user.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: UIConstants.LARGE_FONT, color: Colors.blueAccent),
          ),
        ),
      )
    ]);
  }
}
