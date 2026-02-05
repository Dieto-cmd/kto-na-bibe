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
      body: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Home screen", style: regularTextStyle),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().logOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[700],
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Log out",
                    style: regularTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
