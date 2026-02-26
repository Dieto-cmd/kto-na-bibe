import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/screens/app/friend_selector.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  String? addFriendUid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Card(
                color: Colors.deepPurple,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    "Guest no. ${index + 1}",
                    style: regularTextStyle,
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
                        child: Text("Cancel", style: regularTextStyle),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          try {
                            if (addFriendUid != null) {
                              context.read<BibaCubit>().addFriendToBiba(
                                uid: addFriendUid,
                              );
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
          ),
        );
      },
    );
  }
}
