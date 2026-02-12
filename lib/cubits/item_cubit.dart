import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/models/biba_data.dart';

class ItemCubitState {
  final List<Item>? items;
  final List<CircleAvatar?>? boundUserAvatars;
  ItemCubitState({this.items, this.boundUserAvatars});
}

class ItemCubit extends Cubit<ItemCubitState> {
  ItemCubit({this.cloudRepository})
    : super(ItemCubitState(items: [], boundUserAvatars: null)) {
    getItems();
  }

  final CloudRepository? cloudRepository;

  /*String userNameFromUid(String? uid) {
    return CloudRepository.getUserName();
  }*/

  void getItems() async {
    //simulating getting itemCount from repository
    await Future.delayed(Duration(milliseconds: 500));
    emit(
      ItemCubitState(
        items: cloudRepository?.getItems(),
        boundUserAvatars: cloudRepository?.getBoundUserAvatars(),
      ),
    );
  }
}
