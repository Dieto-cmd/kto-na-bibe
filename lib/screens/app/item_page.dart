import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';

class ItemPage extends StatelessWidget {
  ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) => ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => Placeholder(),
      ),
    );
  }
}

class ItemCheckBox extends StatefulWidget {
  const ItemCheckBox({super.key});

  @override
  State<ItemCheckBox> createState() => _ItemCheckBoxState();
}

class _ItemCheckBoxState extends State<ItemCheckBox> {
  bool? isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Colors.green,
      checkColor: Colors.white,
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
