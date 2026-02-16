import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

abstract class CloudRepository {
  Future<void> updateUserData({
    String? name,
    required String? uid,
    Color? avatarBackgroundColor,
  });
  Future<BibaUserData?> getUserData(String? uid);
  Future<void> addFriend({String? uid, String? friendsUid});
}

class CloudFirestore extends CloudRepository {
  final String? uid;
  CloudFirestore({this.uid});
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> updateUserData({
    String? name,
    required String? uid,
    Color? avatarBackgroundColor,
  }) async {
    int? colorInt = avatarBackgroundColor?.toARGB32();
    Map<String, dynamic> userData;
    if (name == null && avatarBackgroundColor == null) {
      userData = <String, dynamic>{};
    } else if (name == null) {
      userData = <String, dynamic>{'avatarBackgroundColor': colorInt};
    } else {
      userData = <String, dynamic>{'name': name};
    }

    try {
      await db.collection("usersData").doc(uid).update(userData);
    } catch (e) {
      throw "Error occured";
    }
  }

  @override
  Future<void> addFriend({String? uid, String? friendsUid}) async {
    try {
      if (uid != null) {
        Map<String, dynamic> data = <String, dynamic>{
          "friendsList": friendsUid,
        };
        await db.collection("usersData").doc(uid).update(data);
        data = {"friendsList": uid};
        await db.collection("usersData").doc(friendsUid).update(data);
      }
    } catch (e) {
      throw "Error occured";
    }
  }

  Future<void> initiateUserData(String? uid) async {
    DocumentSnapshot doc = await db.collection("usersData").doc(uid).get();
    if (doc.exists) {
      return;
    } else {
      await db.collection("usersData").doc(uid).set({
        'name': 'New User',
        'avatarBackgroundColor': 4283215696,
        'friendsList': [],
      });
    }
  }

  @override
  Future<BibaUserData?> getUserData(String? uid) async {
    try {
      await initiateUserData(uid);
      DocumentSnapshot? doc = await db.collection("usersData").doc(uid).get();
      return _bibaUserDataFromDocumentSnapshot(doc);
    } catch (e) {
      print(e.toString());
      throw "Error occured";
    }
  }
}

BibaUserData _bibaUserDataFromDocumentSnapshot(DocumentSnapshot doc) {
  Color color = Color(doc.get('avatarBackgroundColor'));
  final friendList = doc.get('friendsList');
  List<String>? returnList = [];
  for (dynamic friend in friendList) {
    returnList.add(friend.toString());
  }
  return BibaUserData(
    name: doc.get('name'),
    avatarBackgroundColor: color,
    friendsList: returnList,
  );
}
