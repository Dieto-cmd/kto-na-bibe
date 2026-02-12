import 'package:flutter/material.dart';
import 'package:kto_na_bibe/constants.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Card(
          color: Colors.deepPurple,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text("Guest no. ${index + 1}", style: regularTextStyle),
          ),
        ),
      ),
    );
  }
}
