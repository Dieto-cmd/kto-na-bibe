import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/item_cubit.dart';

class ItemPage extends StatelessWidget {
  ItemPage({super.key});
  final items = ['Speaker', 'Cookies', 'Cola'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemCubitState>(
      builder: (context, state) => ListView.builder(
        itemCount: state.items?.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Card(
            color: Colors.cyan[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ItemCheckBox(),
                    Text(
                      state.items?[index].itemName ?? "Error",
                      style: regularTextStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    state.boundUserAvatars?[index] ??
                        CircleAvatar(backgroundColor: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      state.items?[index].boundUserUid ?? "No one yet",
                      style: regularTextStyle,
                    ),
                  ],
                ),
                Opacity(
                  opacity: 0,
                  child: Row(
                    children: [
                      ItemCheckBox(),
                      Text(
                        state.items?[index].itemName ?? "Error",
                        style: regularTextStyle,
                      ),
                    ],
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
