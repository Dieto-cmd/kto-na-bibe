import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/auth_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                            controller: _passwordController,
                            validator: (value) =>
                                value == null || value.length < 6
                                ? "Password must be 6+ characters long"
                                : null,
                            onChanged: (value) =>
                                setState(() => password = value),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            decoration: textFormFieldDec.copyWith(
                              hintText: "Confirm password",
                              hintStyle: hintTextStyle,
                            ),
                            style: regularTextStyle,
                            obscureText: true,
                            controller: _confirmPasswordController,
                            validator: (value) =>
                                value != _passwordController.text
                                ? "Passwords and repeated password must match"
                                : null,
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
                      await context
                          .read<AuthCubit>()
                          .signUpWithEmailAndPassword(email, password);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[700],
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Sign up",
                      style: regularTextStyle.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Text("Want to Log in?", style: regularTextStyle),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Log in",
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
