import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kto_na_bibe/models/biba_data.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

abstract class CloudRepository {
  Future<void> updateUserData({
    String? name,
    required String? uid,
    Color? avatarBackgroundColor,
  });
  Future<BibaUserData?> getUserData(String? uid);
  Future<void> addFriend({String? uid, String? friendsUid});
  Future<void> deleteFriend({String? uid, String? friendsUid});
  Future<void> createBiba({String? name, String? hostUid, String? place});
  Future<List<BibaData>> getUserFutureBibas({String? uid});
  Future<List<BibaData>> getUserPastBibas({String? uid});
  Future<BibaData> getBibaData({String? bibaId});
  Future<void> addFriendToBiba({String? bibaID, String? friendUid});
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
      DocumentSnapshot friend = await db
          .collection("usersData")
          .doc(friendsUid)
          .get();

      if (friend.exists == false) {
        throw "Couldn't find matching uid";
      }

      if (uid != null) {
        Map<String, dynamic> data = <String, dynamic>{
          "friendsList": [friendsUid],
        };
        await db.collection("usersData").doc(uid).update(data);
        data = {
          "friendsList": [uid],
        };
        await db.collection("usersData").doc(friendsUid).update(data);
      }
    } catch (e) {
      print(e.toString());
      throw "Error occured";
    }
  }

  @override
  Future<void> deleteFriend({String? uid, String? friendsUid}) async {
    try {
      DocumentSnapshot friend = await db
          .collection("usersData")
          .doc(friendsUid)
          .get();

      if (friend.exists == false) {
        throw "Couldn't find matching uid";
      }

      if (uid != null) {
        Map<String, dynamic> data = <String, dynamic>{
          "friendsList": FieldValue.arrayRemove([friendsUid]),
        };
        await db.collection("usersData").doc(uid).update(data);
        data = {
          "friendsList": FieldValue.arrayRemove([uid]),
        };
        await db.collection("usersData").doc(friendsUid).update(data);
      }
    } catch (e) {
      print(e.toString());
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
  Future<void> createBiba({
    String? name,
    String? hostUid,
    String? place,
  }) async {
    try {
      await db.collection("Bibas").doc().set({
        'name': name,
        'hostUid': hostUid,
        'place': place,
        'guestUids': [],
      });
    } catch (e) {
      print(e.toString());
      throw "Error occured";
    }
  }

  Future<void> deleteNewUsersData() async {
    final snapshot = await db
        .collection("usersData")
        .where(Filter("name", isEqualTo: "New User"))
        .get();
    for (final doc in snapshot.docs) {
      await db.collection("usersData").doc(doc.id).delete();
    }
  }

  @override
  Future<List<BibaData>> getUserFutureBibas({String? uid}) async {
    List<BibaData> bibaList = [];
    final snapshot = await db
        .collection("Bibas")
        .where(
          Filter.or(
            Filter('hostUid', isEqualTo: uid),
            Filter('guestUids', arrayContains: uid),
          ),
        )
        .get();
    for (final doc in snapshot.docs) {
      final biba = doc.data();
      List<String?> guestNames = [];
      for (final guestUid in biba["guestUids"]) {
        guestNames.add(await getUserName(uid: guestUid));
      }

      bibaList.add(
        BibaData(
          hostId: biba["hostUid"],
          hostName: await getUserName(uid: biba["hostUid"]),
          guestsIds: List<String>.from(biba["guestUids"] ?? []),
          guestNames: guestNames,
          name: biba["name"],
          place: biba["place"],
          bibaId: doc.id,
        ),
      );
    }
    return bibaList;
  }

  @override
  Future<List<BibaData>> getUserPastBibas({String? uid}) async {
    List<BibaData> bibaList = [];
    final snapshot = await db
        .collection("Bibas")
        .where(
          Filter.or(
            Filter('hostUid', isEqualTo: uid),
            Filter('guestUids', arrayContains: uid),
          ),
        )
        .get();
    for (final doc in snapshot.docs) {
      final biba = doc.data();
      List<String?> guestNames = [];
      for (final guestUid in biba["guestUids"]) {
        guestNames.add(await getUserName(uid: guestUid));
      }

      bibaList.add(
        BibaData(
          hostId: biba["hostUid"],
          hostName: await getUserName(uid: biba["hostUid"]),
          guestsIds: List<String>.from(biba["guestUids"] ?? []),
          guestNames: guestNames,
          name: biba["name"],
          place: biba["place"],
          bibaId: doc.id,
        ),
      );
    }
    return bibaList;
  }

  @override
  Future<BibaData> getBibaData({String? bibaId}) async {
    try {
      DocumentSnapshot doc = await db.collection("Bibas").doc(bibaId).get();

      final friendUidList = List<String>.from(doc.get('guestUids') ?? []);
      List<String?> friendNameList = [];

      for (String uid in friendUidList) {
        friendNameList.add(await getUserName(uid: uid));
      }

      final hostName = await getUserName(uid: doc.get('hostUid'));

      return BibaData(
        name: doc.get('name'),
        hostId: doc.get('hostUid'),
        hostName: hostName,
        bibaId: doc.id,
        guestsIds: friendUidList,
        guestNames: friendNameList,
        place: doc.get('place'),
      );
    } catch (e) {
      print("Printing exception thrown in getBibaData: ${e.toString()}");
      return BibaData();
    }
  }

  @override
  Future<void> addFriendToBiba({String? bibaID, String? friendUid}) async {
    try {
      await db.collection("Bibas").doc(bibaID).update({
        'guestUids' : FieldValue.arrayUnion([friendUid])
      });
    } catch (e) {
      print("Printing exception thrown in addFriendToBiba: ${e.toString()}");
    }
  }

  Future<String?> getUserName({String? uid}) async {
    try {
      BibaUserData? data = await getUserData(uid);
      return data?.name;
    } catch (e) {
      return e.toString();
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
