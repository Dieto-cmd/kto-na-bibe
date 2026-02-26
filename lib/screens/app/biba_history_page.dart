import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/screens/app/biba_page.dart';

class BibaHistoryPage extends StatelessWidget {
  const BibaHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) => ListView.builder(
        itemCount: state.pastBibaList?.length ?? 0,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(top: 20),

          child: GestureDetector(
            onTap: () {
              final userCubit = context.read<UserCubit>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: userCubit),

                      BlocProvider<BibaCubit>(
                        create: (context) => BibaCubit(
                          cloudRepository: CloudFirestore(),
                          bibaId: state.pastBibaList?[index].bibaId,
                        ),
                      ),
                    ],

                    child: BibaPage(),
                  ),
                ),
              );
            },
            child: Card(
              elevation: 0,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  leading: Image.asset(
                    "assets/icons/Biba_B_logo.png",
                    height: 44,
                  ),
                  title: Text(
                    state.pastBibaList?[index].name ?? "Error",
                    style: regularTextStyle,
                  ),
                  subtitle: Text(
                    "Date: 21/02/2025, "
                    "Host: ${state.pastBibaList?[index].hostName},"
                    "Place: ${state.pastBibaList?[index].place}, "
                    "Guests: ${state.pastBibaList?[index].guestsIds?.length}",
                    style: hintTextStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
