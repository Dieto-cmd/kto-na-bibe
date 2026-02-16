import 'package:flutter/material.dart';
import 'package:kto_na_bibe/models/biba_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

abstract class CloudRepository {
  List<CircleAvatar?> getBoundUserAvatars();
  void bindUser({String? itemId, String? userUid});
  void unBindUser({String? itemId});
  List<Item>? getItems();
  Future<void> updateUserData({
    String? name,
    required String? uid,
    Color? avatarBackgroundColor,
  });
  Future<BibaUserData?> getUserData(String? uid);
}

class CloudFirestore extends CloudRepository {
  List<CircleAvatar?> boundUserAvatars = [
    CircleAvatar(backgroundColor: Colors.blue),
    null,
    CircleAvatar(backgroundColor: Colors.amber),
    CircleAvatar(backgroundColor: Colors.red),
    null,
    null,
  ];

  BibaData data = BibaData(
    hostId: null,
    guestsIds: null,
    items: [
      Item(itemName: "Speaker", boundUserUid: "1", itemId: "4"),
      Item(itemName: "Cookies", boundUserUid: null, itemId: "3"),
      Item(itemName: "Cola", boundUserUid: "3", itemId: "2"),
      Item(itemName: "Baloons", boundUserUid: "4", itemId: "1"),
    ],
  );

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
  Future<BibaUserData?> getUserData(String? uid) async {
    try {
      DocumentSnapshot doc = await db.collection("usersData").doc(uid).get();
      return _bibaUserDataFromDocumentSnapshot(doc);
    } catch (e) {
      throw "Error occured";
    }
  }

  @override
  List<CircleAvatar?> getBoundUserAvatars() {
    return boundUserAvatars;
  }

  @override
  List<Item>? getItems() {
    return data.items;
  }

  @override
  void bindUser({String? itemId, String? userUid}) {
    for (Item item in data.items ?? []) {
      if (item.itemId == itemId) {
        item.boundUserUid = userUid;
      }
    }
  }

  @override
  void unBindUser({String? itemId}) {
    for (Item item in data.items ?? []) {
      if (item.itemId == itemId) {
        item.boundUserUid = null;
      }
    }
  }
}

BibaUserData _bibaUserDataFromDocumentSnapshot(DocumentSnapshot doc) {
  Color color = Color(doc.get('avatarBackgroundColor'));
  return BibaUserData(name: doc.get('name'), avatarBackgroundColor: color);
}
