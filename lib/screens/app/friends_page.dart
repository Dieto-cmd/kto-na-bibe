import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.black,
        body: ListView.builder(
          itemCount: state.friendsList?.length,
          itemBuilder: (context, index) {
            if (state.friendsList?.length == 0) {
              return Container();
            }
            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: Card(
                elevation: 0,
                color: Colors.amber,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          state.friendsDataList?[index].avatarBackgroundColor,
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
          onPressed: () {},
          child: Icon(Icons.add, color: Colors.white, size: 45),
        ),
      ),
    );
  }
}
