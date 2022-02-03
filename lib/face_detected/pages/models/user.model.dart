import 'package:flutter/material.dart';

class User {
  String? user;
  String? password;
  String? predictedData;

  User(
      {@required this.user,
      @required this.password,
      @required this.predictedData});

  static User fromDB(String? dbuser, List? dataface) {
    return new User(
        user: dbuser!.split(':')[0],
        password: dbuser.split(':')[1],
        predictedData: dataface.toString());
  }
}
