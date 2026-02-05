import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/auth_cubit.dart';
import 'screens/authentication/authenticate_page.dart';
import 'screens/home_page.dart';
import 'screens/loading_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        if (state.status == AuthCubitStatus.authenticated) {
          return HomePage();
        } else if (state.status == AuthCubitStatus.loading) {
          return LoadingPage();
        } else {
          return AuthenticatePage();
        }
      },
    );
  }
}
