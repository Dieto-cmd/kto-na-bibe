import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/models/biba_data.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';

class BibaCubitState {
  BibaData? data;
  BibaCubitStatus? status;

  BibaCubitState({this.data, this.status});
}

enum BibaCubitStatus { loadingData, dataLoaded }

class BibaCubit extends Cubit<BibaCubitState> {
  BibaCubit({this.cloudRepository, this.bibaId})
    : super(BibaCubitState(status: BibaCubitStatus.loadingData)) {
    getBibaData();
  }

  final CloudRepository? cloudRepository;
  final String? bibaId;
  BibaData? data;
  Future<void> getBibaData() async {
    data = await cloudRepository?.getBibaData(bibaId: bibaId);
    emit(BibaCubitState(data: data, status: BibaCubitStatus.dataLoaded));
  }

  Future<void> addFriendToBiba({String? uid}) async {
    await cloudRepository?.addFriendToBiba(bibaID: bibaId, friendUid: uid);
    getBibaData();
    emit(BibaCubitState(data: state.data ,status: BibaCubitStatus.dataLoaded));
  }
}
