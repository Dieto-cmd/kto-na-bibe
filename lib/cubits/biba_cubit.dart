import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';

class BibaCubitState {
  String? name;
  String? place;
  String? hostUid;
  List<String>? guestsUids;

  BibaCubitState({this.guestsUids, this.hostUid, this.name, this.place});
}

class BibaCubit extends Cubit<BibaCubitState> {
  BibaCubit({this.cloudRepository}) : super(BibaCubitState());
  final CloudRepository? cloudRepository;

  

  void getBibaData() {}
}
