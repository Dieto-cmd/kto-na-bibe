import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/cubits/auth_cubit.dart';
import 'package:kto_na_bibe/screens/authentication/login_page.dart';
import 'package:kto_na_bibe/screens/authentication/verify_email_page.dart';
import 'package:kto_na_bibe/screens/home_page.dart';
import 'package:kto_na_bibe/screens/loading_page.dart';
import 'package:kto_na_bibe/screens/splash_page.dart';

class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({super.key});

  @override
  State<AuthenticatePage> createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthCubitStatus.initial:
            return SplashPage();
          case AuthCubitStatus.loading:
            return LoadingPage();
          case AuthCubitStatus.unauthenticated:
            return LoginPage();
          case AuthCubitStatus.error:
            return LoginPage(errorMessage: state.errorMessage);
          case AuthCubitStatus.authenticated:
            return HomePage();
          case AuthCubitStatus.verificationNeeded:
            return VerifyEmailPage(errorMessage: state.errorMessage,);
        }
      },
    );
  }
}
