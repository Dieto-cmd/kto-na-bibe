import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/models/biba_data.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

class UserCubitState {
  final List<Item>? items;
  final List<CircleAvatar?>? boundUserAvatars;
  final String? userName;
  final Color? avatarBackgroundColor;
  final List<String>? friendsList;
  UserCubitState({
    this.items,
    this.boundUserAvatars,
    this.userName,
    this.avatarBackgroundColor,
    this.friendsList,
  });
}

class UserCubit extends Cubit<UserCubitState> {
  UserCubit({this.cloudRepository, this.uid})
    : super(
        UserCubitState(),
      ) {
    getUserData();
  }

  final CloudRepository? cloudRepository;
  final String? uid;

  Future<void> getUserData() async {
    BibaUserData? data = await cloudRepository?.getUserData(uid);
    emit(
      UserCubitState(
        userName: data?.name,
        avatarBackgroundColor: data?.avatarBackgroundColor,
        friendsList: data?.friendsList,
        items: cloudRepository?.getItems(),
        boundUserAvatars: cloudRepository?.getBoundUserAvatars(),
      ),
    );
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
        items: cloudRepository?.getItems(),
        boundUserAvatars: cloudRepository?.getBoundUserAvatars(),
        ),
      );
    } catch (e) {
      print(e.toString());
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
        items: cloudRepository?.getItems(),
        boundUserAvatars: cloudRepository?.getBoundUserAvatars(),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

}
