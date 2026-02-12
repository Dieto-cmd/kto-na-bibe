import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/models/biba_data.dart';

class CloudCubitState {
  final List<Item>? items;
  final List<CircleAvatar?>? boundUserAvatars;
  final String? userName;
  CloudCubitState({this.items, this.boundUserAvatars, this.userName});
}

class CloudCubit extends Cubit<CloudCubitState> {
  CloudCubit({this.cloudRepository, this.uid})
    : super(
        CloudCubitState(items: [], boundUserAvatars: null, userName: null),
      ) {
    getItems();
  }

  final CloudRepository? cloudRepository;
  final String? uid;

  Future<void> initiateUserDatabase(String? uid) async {
    try {
      await cloudRepository?.updateUserData(name: null, uid: uid);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setName({String? newName, String? uid}) async {
    await cloudRepository?.updateUserData(name: newName, uid: uid);
    emit(CloudCubitState(userName: await cloudRepository?.getUserName(uid)));
  }

  void getItems() async {
    //simulating getting itemCount from repository
    await Future.delayed(Duration(milliseconds: 500));
    emit(
      CloudCubitState(
        items: cloudRepository?.getItems(),
        boundUserAvatars: cloudRepository?.getBoundUserAvatars(),
      ),
    );
  }
}
