import 'package:flutter/material.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.errorMessage != null) {
      _showError(widget.errorMessage!);
    }
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: regularTextStyle),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text("Kto na bibe", style: regularTextStyle),
          centerTitle: true,
          backgroundColor: Colors.pink[700],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 80, color: Colors.pink[700]),
              SizedBox(height: 20),
              Text(
                "Verification link has been send to your email",
                textAlign: TextAlign.center,
                style: regularTextStyle,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[700],
                ),
                onPressed: () {
                  context.read<AuthCubit>().checkEmailVerification();
                },
                child: Text(
                  "I already confirmed my email",
                  style: regularTextStyle,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.read<AuthCubit>().resendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Verification email has been resent",
                        style: regularTextStyle,
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                },

                child: Text(
                  "Resend verification email",
                  style: regularTextStyle.copyWith(
                    color: Colors.amber,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: () => context.read<AuthCubit>().logOut(),
                child: Text(
                  "Go back to login screen",
                  style: regularTextStyle.copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
