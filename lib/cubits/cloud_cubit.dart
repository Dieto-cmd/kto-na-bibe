import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/models/biba_data.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

class CloudCubitState {
  final List<Item>? items;
  final List<CircleAvatar?>? boundUserAvatars;
  final String? userName;
  final Color? avatarBackgroundColor;
  CloudCubitState({
    this.items,
    this.boundUserAvatars,
    this.userName,
    this.avatarBackgroundColor,
  });
}

class CloudCubit extends Cubit<CloudCubitState> {
  CloudCubit({this.cloudRepository, this.uid})
    : super(
        CloudCubitState(items: [], boundUserAvatars: null, userName: null),
      ) {
    getUserData();
  }

  final CloudRepository? cloudRepository;
  final String? uid;

  Future<void> getUserData() async {
    BibaUserData? data = await cloudRepository?.getUserData(uid);
    emit(
      CloudCubitState(
        userName: data?.name,
        avatarBackgroundColor: data?.avatarBackgroundColor,
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
        CloudCubitState(
          userName: data?.name,
          avatarBackgroundColor: data?.avatarBackgroundColor,
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
        CloudCubitState(
          userName: data?.name,
          avatarBackgroundColor: data?.avatarBackgroundColor,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
