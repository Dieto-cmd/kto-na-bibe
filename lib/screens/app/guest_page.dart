import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/screens/app/friend_selector.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key, this.isHost});
  final bool? isHost;

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  String? addFriendUid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibaCubit, BibaCubitState>(
      builder: (bibaContext, bibaState) {
        return BlocBuilder<UserCubit, UserCubitState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: ListView.builder(
                itemCount: (bibaState.data?.guestsIds?.length ?? 0) + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Card(
                        color: Colors.amber[700],
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                bibaState.data?.hostBackgroundColor,
                            child: Icon(
                              Icons.star,
                              color: Colors.white,
                            ), // Zamiast person, dajemy gwiazdkę
                          ),
                          title: Text(
                            bibaState.data?.hostName ??
                                "Unknown Host", // Pobieramy imię hosta
                            style: regularTextStyle,
                          ),
                          subtitle: Text(
                            "Host",
                            style: regularTextStyle.copyWith(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final guestIndex = index - 1;

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      color: Colors.deepPurple,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: bibaState
                              .data
                              ?.guestsBackgroundColors?[guestIndex],
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          bibaState.data?.guestNames?[guestIndex] ?? "Unknown",
                          style: regularTextStyle,
                        ),
                        subtitle: Text(
                          "Guest",
                          style: regularTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: (widget.isHost ?? false)
                  ? FloatingActionButton(
                      onPressed: () {
                        final userCubit = context.read<UserCubit>();
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: Text("Add guest", style: regularTextStyle),
                              content: BlocProvider.value(
                                value: userCubit,
                                child: SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: FriendSelector(
                                    onFriendSelected: (friendUid) {
                                      setState(() {
                                        addFriendUid = friendUid;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Cancel",
                                    style: regularTextStyle,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                  ),
                                  onPressed: () {
                                    try {
                                      if (addFriendUid != null) {
                                        context
                                            .read<BibaCubit>()
                                            .addFriendToBiba(uid: addFriendUid);
                                      }

                                      Navigator.pop(context);
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: Text("Add", style: regularTextStyle),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      backgroundColor: Colors.pink[700],
                      child: Icon(Icons.add, color: Colors.white, size: 45),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
