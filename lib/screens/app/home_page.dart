import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/auth_cubit.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/screens/app/biba_history_page.dart';
import 'package:kto_na_bibe/screens/app/color_selector.dart';
import 'package:kto_na_bibe/screens/app/future_bibas_page.dart';
import 'package:kto_na_bibe/screens/app/friends_page.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.uid});
  final String? uid;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color? avatarBackgroundColor;
  String? userName;
  bool dataIsLoaded = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.black,
            endDrawer: Drawer(
              backgroundColor: Colors.grey[900],
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(color: Colors.pink[700]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    "Background avatar color",
                                    style: regularTextStyle,
                                  ),
                                  content: ColorSelector(
                                    initialColor: avatarBackgroundColor,
                                    onColorSelected: (newColor) {
                                      setState(() {
                                        avatarBackgroundColor = newColor;
                                      });
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "Cancel",
                                        style: regularTextStyle,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<UserCubit>()
                                            .setAvatarBackgroundColor(
                                              uid: widget.uid,
                                              avatarBackgroundColor:
                                                  avatarBackgroundColor,
                                            );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Save changes",
                                        style: regularTextStyle,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: state.avatarBackgroundColor,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            final userCubit = context.read<UserCubit>();
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                TextEditingController _controller =
                                    TextEditingController();

                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    "Change your name",
                                    style: regularTextStyle,
                                  ),
                                  content: TextField(
                                    controller: _controller,
                                    style: regularTextStyle,
                                    decoration: textFormFieldDec.copyWith(
                                      hintText: "Enter new name",
                                      hintStyle: hintTextStyle,
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
                                      onPressed: () async {
                                        await userCubit.setName(
                                          newName: _controller.text,
                                          uid: widget.uid,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Save",
                                        style: regularTextStyle,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.userName ?? "Undefined",
                                style: regularTextStyle.copyWith(fontSize: 25),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: widget.uid ?? ""),
                                  );

                                  if (context.mounted) {
                                    Navigator.of(context).pop();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Uid copied to clipboard",
                                          style: regularTextStyle,
                                        ),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "uid: ${widget.uid ?? "Undefined"}",
                                        style: regularTextStyle.copyWith(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      "Logout",
                      style: regularTextStyle.copyWith(color: Colors.red),
                    ),
                    onTap: () => context.read<AuthCubit>().logOut(),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text("Kto na bibe", style: regularTextStyle),
              centerTitle: true,
              backgroundColor: Colors.pink[700],
              actions: [
                Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.amber,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: state.avatarBackgroundColor,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.amber,
                indicatorWeight: 1.0,
                unselectedLabelColor: Colors.grey,
                labelStyle: regularTextStyle.copyWith(fontSize: 16),
                tabs: [
                  Tab(text: "Biba History"),
                  Tab(text: "Future Bibas"),
                  Tab(text: "Freinds"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                BibaHistoryPage(),
                FutureBibasPage(uid: widget.uid),
                FriendsPage(uid: widget.uid),
              ],
            ),
          ),
        );
      },
    );
  }
}
