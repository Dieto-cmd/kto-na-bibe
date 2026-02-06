import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/models/biba_user.dart';
import 'package:kto_na_bibe/repositories/auth_repository.dart';
import 'dart:async';

enum AuthCubitStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  verificationNeeded,
}

class AuthCubitState {
  final AuthCubitStatus status;
  final String? errorMessage;

  const AuthCubitState({
    this.status = AuthCubitStatus.initial,
    this.errorMessage,
  });
}

class AuthCubit extends Cubit<AuthCubitState> {
  AuthRepository authRepository;

  AuthCubit({required this.authRepository})
    : super(AuthCubitState(status: AuthCubitStatus.initial)) {
    _checkCurrentUser();
    _startListeningToAuthChanges();
  }

  void _startListeningToAuthChanges() {
    authRepository.user.listen((BibaUser? user) async {
      if (user == null) {
        emit(AuthCubitState(status: AuthCubitStatus.unauthenticated));
      } else {
        final isEmailVerified = await authRepository.isEmailVerified();
        if (isEmailVerified) {
          emit(AuthCubitState(status: AuthCubitStatus.authenticated));
        } else {
          emit(AuthCubitState(status: AuthCubitStatus.verificationNeeded));
        }
      }
    });
  }

  void _checkCurrentUser() async {
    await Future.delayed(Duration(seconds: 2));
    final bool userLoggedIn = authRepository.isUserLoggedIn();
    if (userLoggedIn == true) {
      final isEmailVerified = await authRepository.isEmailVerified();
      if (isEmailVerified) {
        emit(AuthCubitState(status: AuthCubitStatus.authenticated));
      } else {
        emit(AuthCubitState(status: AuthCubitStatus.verificationNeeded));
      }
    } else {
      emit(AuthCubitState(status: AuthCubitStatus.unauthenticated));
    }
  }

  Future<void> logInWithEmailAndPassword(String email, String password) async {
    emit(AuthCubitState(status: AuthCubitStatus.loading));
    try {
      await authRepository.logInWithEmailAndPassword(email, password);
    } catch (e) {
      emit(
        AuthCubitState(
          status: AuthCubitStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    emit(AuthCubitState(status: AuthCubitStatus.loading));
    try {
      await authRepository.signUpWithEmailAndPassword(email, password);

      await authRepository.sendEmailVerification();
      emit(AuthCubitState(status: AuthCubitStatus.verificationNeeded));
    } catch (e) {
      emit(
        AuthCubitState(
          status: AuthCubitStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthCubitState(status: AuthCubitStatus.loading));
    try {
      await authRepository.signInWithGoogle();
    } catch (e) {
      emit(
        AuthCubitState(
          status: AuthCubitStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> checkEmailVerification() async {
    emit(AuthCubitState(status: AuthCubitStatus.loading));
    final isEmailVerified = await authRepository.isEmailVerified();
    if (isEmailVerified) {
      emit(AuthCubitState(status: AuthCubitStatus.authenticated));
    } else {
      emit(
        AuthCubitState(
          status: AuthCubitStatus.verificationNeeded,
          errorMessage: "Email hasn't been confirmed",
        ),
      );
    }
  }

  Future<void> resendEmailVerification() async {
    await authRepository.sendEmailVerification();
  }

  Future<void> logOut() async {
    await authRepository.logOut();
  }
}
