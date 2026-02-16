import 'package:flutter/material.dart';

class BibaUser {
  final String? uid;
  BibaUser({this.uid});
}

class BibaUserData {
  final String? name;
  final Color? avatarBackgroundColor;
  final List<String>? friendsList;

  BibaUserData({this.name, this.avatarBackgroundColor, this.friendsList});
}
