import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key, this.uid});
  final String? uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.black,
        body: (state.friendsList?.isEmpty ?? false)
            ? Center(
                child: Text(
                  "You have no friends as of now",
                  style: regularTextStyle.copyWith(fontSize: 25),
                ),
              )
            : ListView.builder(
                itemCount: state.friendsList?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 0,
                      color: Colors.amber,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: state
                                .friendsDataList?[index]
                                .avatarBackgroundColor,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            state.friendsDataList?[index].name ?? "Unknown",
                            style: regularTextStyle,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            final userCubit = context.read<UserCubit>();
            showDialog(
              context: context,
              builder: (dialogContext) {
                TextEditingController _controller = TextEditingController();
                return AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text("Add a friend", style: regularTextStyle),
                  content: TextField(
                    controller: _controller,
                    style: regularTextStyle,
                    decoration: textFormFieldDec.copyWith(
                      hintText: "Enter friend's uid",
                      hintStyle: hintTextStyle,
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
                          await userCubit.addFriend(uid, _controller.text);
                          Navigator.pop(context);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                title: Text(
                                  "Uid doesn't exist",
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
                                    child: Text("Ok", style: regularTextStyle),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text("Add", style: regularTextStyle),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add, color: Colors.white, size: 45),
        ),
      ),
    );
  }
}
