import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/auth_cubit.dart';
import 'package:kto_na_bibe/screens/authentication/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[700],
        title: Text(
          "Kto Na Bibe",
          style: regularTextStyle.copyWith(fontSize: 30),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) => Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            decoration: textFormFieldDec.copyWith(
                              hintText: "Email",
                              hintStyle: hintTextStyle,
                            ),
                            style: regularTextStyle,
                            validator: (value) =>
                                value!.isEmpty ? "Enter an email" : null,
                            onChanged: (value) => setState(() => email = value),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            decoration: textFormFieldDec.copyWith(
                              hintText: "Password",
                              hintStyle: hintTextStyle,
                            ),
                            style: regularTextStyle,
                            obscureText: true,
                            validator: (value) => value!.length < 6
                                ? "Password must be 6+ characters long"
                                : null,
                            onChanged: (value) =>
                                setState(() => password = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<AuthCubit>().logInWithEmailAndPassword(
                        email,
                        password,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[700],
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Log in",
                      style: regularTextStyle.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () =>
                        context.read<AuthCubit>().signInWithGoogle(),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/icons/Google__G__logo.svg.png', height: 24,),

                          Text(
                            "Continue with Google",
                            style: regularTextStyle.copyWith(
                              color: Colors.black,
                            ),
                          ),

                          Opacity(
                            opacity: 0.0,
                            child: Image.asset(
                              'assets/icons/Google__G__logo.svg.png',
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Text("You don't have an account?", style: regularTextStyle),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: regularTextStyle.copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
