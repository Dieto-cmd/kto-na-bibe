import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';

class FriendSelector extends StatefulWidget {
  const FriendSelector({super.key, this.onFriendSelected});
  final Function(String?)? onFriendSelected;

  @override
  State<FriendSelector> createState() => _FriendSelectorState();
}

class _FriendSelectorState extends State<FriendSelector> {
  String? selectedFriendUid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.friendsList?.length ?? 0,
          itemBuilder: (context, index) {
            final currentUid = state.friendsList?[index];
            final isSelected = selectedFriendUid == currentUid;
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFriendUid = currentUid;
                  });

                  widget.onFriendSelected?.call(currentUid);
                },
                child: Card(
                  elevation: isSelected ? 4 : 0,
                  color: isSelected ? Colors.amber[700] : Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
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
              ),
            );
          },
        );
      },
    );
  }
}
