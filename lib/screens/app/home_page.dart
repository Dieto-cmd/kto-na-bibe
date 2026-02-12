import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/auth_cubit.dart';
import 'package:kto_na_bibe/cubits/cloud_cubit.dart';
import 'package:kto_na_bibe/screens/app/biba_history_page.dart';
import 'package:kto_na_bibe/screens/app/future_bibas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.uid});
  final String? uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CloudCubit, CloudCubitState>(
      builder: (context, state) => DefaultTabController(
        length: 2,
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
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          final cloudCubit = context.read<CloudCubit>();
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
                                      await cloudCubit.setName(
                                        newName: _controller.text,
                                        uid: uid,
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
                        child: Text(
                          state.userName ?? "Undefined",
                          style: regularTextStyle.copyWith(fontSize: 25),
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
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
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
              ],
            ),
          ),
          body: TabBarView(children: [BibaHistoryPage(), FutureBibasPage()]),
        ),
      ),
    );
  }
}
