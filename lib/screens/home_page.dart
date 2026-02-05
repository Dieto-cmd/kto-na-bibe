import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  CircleAvatar(radius: 30, backgroundColor: Colors.blue),
                  SizedBox(height: 10),
                  Text("Your Profile", style: regularTextStyle),
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
                      child: Icon(Icons.person, color: Colors.black, size: 18),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Home screen", style: regularTextStyle)],
          ),
        ),
      ),
    );
  }
}
