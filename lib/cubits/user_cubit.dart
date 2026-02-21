import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

class UserCubitState {
  final String? userName;
  final Color? avatarBackgroundColor;
  final List<String>? friendsList;
  final List<BibaUserData>? friendsDataList;
  UserCubitState({
    this.userName,
    this.avatarBackgroundColor,
    this.friendsList,
    this.friendsDataList,
  });
}

class UserCubit extends Cubit<UserCubitState> {
  UserCubit({this.cloudRepository, this.uid}) : super(UserCubitState()) {
    getUserData(uid);
  }

  final CloudRepository? cloudRepository;
  final String? uid;

  Future<void> getUserData(String? uid) async {
    try {
      BibaUserData? data = await cloudRepository?.getUserData(uid);
      List<String>? friendsList = data?.friendsList;

      List<BibaUserData>? friendsDataList = [];
      for (String friendUid in friendsList ?? []) {
        final friendData = await cloudRepository?.getUserData(friendUid);
        friendsDataList.add(
          BibaUserData(
            name: friendData?.name,
            avatarBackgroundColor: friendData?.avatarBackgroundColor,
          ),
        );
      }

      emit(
        UserCubitState(
          userName: data?.name,
          avatarBackgroundColor: data?.avatarBackgroundColor,
          friendsList: friendsList,
          friendsDataList: friendsDataList,
        ),
      );
    } catch (e) {
      print(e.toString);
      emit(
        UserCubitState(
          userName: "Unknown",
          avatarBackgroundColor: Colors.grey,
          friendsList: [],
          friendsDataList: [],
        ),
      );
    }
  }

  Future<void> setName({String? newName, String? uid}) async {
    try {
      await cloudRepository?.updateUserData(name: newName, uid: uid);
      BibaUserData? data = await cloudRepository?.getUserData(uid);
      emit(
        UserCubitState(
          userName: data?.name,
          avatarBackgroundColor: data?.avatarBackgroundColor,
          friendsList: data?.friendsList,
          friendsDataList: state.friendsDataList,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addFriend(String? uid, String? friendUid) async {
    try {
      await cloudRepository?.addFriend(uid: uid, friendsUid: friendUid);
      BibaUserData? data = await cloudRepository?.getUserData(uid);
      emit(
        UserCubitState(
          userName: data?.name,
          avatarBackgroundColor: data?.avatarBackgroundColor,
          friendsList: data?.friendsList,
          friendsDataList: state.friendsDataList,
        ),
      );
    } catch (e) {
      throw "Error occured";
    }
  }

  Future<void> deleteFriend(String? uid, String? friendUid) async {
    try {
      await cloudRepository?.deleteFriend(uid: uid, friendsUid: friendUid);
      BibaUserData? data = await cloudRepository?.getUserData(uid);
      emit(
        UserCubitState(
          userName: data?.name,
          avatarBackgroundColor: data?.avatarBackgroundColor,
          friendsList: data?.friendsList,
          friendsDataList: state.friendsDataList,
        ),
      );
    } catch (e) {
      throw "Error occured";
    }
  }

  Future<void> setAvatarBackgroundColor({
    Color? avatarBackgroundColor,
    String? uid,
  }) async {
    try {
      await cloudRepository?.updateUserData(
        avatarBackgroundColor: avatarBackgroundColor,
        uid: uid,
      );
      BibaUserData? data = await cloudRepository?.getUserData(uid);
      emit(
        UserCubitState(
          userName: data?.name,
          avatarBackgroundColor: data?.avatarBackgroundColor,
          friendsList: data?.friendsList,
          friendsDataList: state.friendsDataList,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createBiba({
    String? name,
    String? place,
    String? hostUid,
  }) async {
    try {
      await cloudRepository?.createBiba(
        name: name,
        place: place,
        hostUid: hostUid,
      );
    } catch (e) {
      throw "Error occured";
    }
  }
}
