import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/cubits/cloud_cubit.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'cubits/auth_cubit.dart';
import 'screens/authentication/authenticate_page.dart';
import 'screens/app/home_page.dart';
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
          return BlocProvider<CloudCubit>(
            create: (_) =>
                CloudCubit(cloudRepository: CloudFirestore(), uid: state.uid),
            child: HomePage(uid: state.uid),
          );
        } else if (state.status == AuthCubitStatus.loading) {
          return LoadingPage();
        } else {
          return AuthenticatePage();
        }
      },
    );
  }
}
