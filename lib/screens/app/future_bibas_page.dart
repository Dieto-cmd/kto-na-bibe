import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/screens/app/biba_page.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';

class FutureBibasPage extends StatelessWidget {
  const FutureBibasPage({super.key, this.uid});
  final uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: ListView.builder(
            itemCount: state.futureBibaList?.length ?? 0,
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
                        (state.futureBibaList?[index].name ?? "Error"),
                        style: regularTextStyle,
                      ),
                      subtitle: Text(
                        "Date: 21/02/2026,"
                        " Host: ${state.futureBibaList?[index].hostName},"
                        " Place: ${state.futureBibaList?[index].place}"
                        " Guests: ${state.futureBibaList?[index].guestsIds?.length ?? 0}",
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

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final userCubit = context.read<UserCubit>();
              showDialog(
                context: context,
                builder: (dialogContext) {
                  TextEditingController _nameController =
                      TextEditingController();
                  TextEditingController _placeController =
                      TextEditingController();
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text("Create new biba", style: regularTextStyle),
                    content: Container(
                      height: 140,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            style: regularTextStyle,
                            decoration: textFormFieldDec.copyWith(
                              hintText: "Enter biba's name",
                              hintStyle: hintTextStyle,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _placeController,
                            style: regularTextStyle,
                            decoration: textFormFieldDec.copyWith(
                              hintText: "Enter biba's location",
                              hintStyle: hintTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel", style: regularTextStyle),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () async {
                          try {
                            await userCubit.createBiba(
                              name: _nameController.text,
                              place: _placeController.text,
                              hostUid: uid,
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    "Something went wrong",
                                    style: regularTextStyle,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                      ),
                                      child: Text(
                                        "Ok",
                                        style: regularTextStyle,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text("Create", style: regularTextStyle),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Colors.pink[700],
            child: Icon(Icons.add, color: Colors.white, size: 45),
          ),
        );
      },
    );
  }
}
