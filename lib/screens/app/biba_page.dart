import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/screens/app/biba_info_page.dart';
import 'package:kto_na_bibe/screens/app/guest_page.dart';

class BibaPage extends StatelessWidget {
  const BibaPage({super.key, this.isNotPastBiba});
  final bool? isNotPastBiba;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (userContext, userState) {
        return BlocBuilder<BibaCubit, BibaCubitState>(
          builder: (context, state) {
            // Generally it's ill-advised to store variables inside a cubit
            //rather than a cubit state, but the situation where uid needs to be
            //read from UserCubit is very rare
            bool isHost =
                state.data?.hostId == userContext.read<UserCubit>().uid;
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.pink[700],
                  title: Text(
                    state.data?.name ?? "Unknown",
                    style: regularTextStyle,
                  ),
                  centerTitle: true,
                  leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  actions: ((isNotPastBiba ?? false) && isHost == true)
                      ? [
                          GestureDetector(
                            onTap: () {
                              final bibaCubit = context.read<BibaCubit>();
                              final userCubit = userContext.read<UserCubit>();
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Text(
                                      "Do you want to delete this Biba?",
                                      style: regularTextStyle,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          "Cancel",
                                          style: regularTextStyle,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          bibaCubit.deleteBiba();
                                          userCubit.getUserFutureBibas();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Delete",
                                          style: regularTextStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.more_vert, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                        ]
                      : null,
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.amber,
                    indicatorWeight: 1.0,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: regularTextStyle.copyWith(fontSize: 16),
                    tabs: [
                      Tab(text: "Guests"),
                      Tab(text: "Info"),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    GuestPage(isHost: isHost, isNotPastBiba: isNotPastBiba),
                    BibaInfoPage(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
