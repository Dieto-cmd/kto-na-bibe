import 'package:flutter/material.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/screens/app/biba_page.dart';

class FutureBibasPage extends StatelessWidget {
  const FutureBibasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => BibaPage())),
            child: Card(
              elevation: 0,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  leading: Image.asset(
                    "assets/icons/Biba_B_logo.png",
                    height: 44,
                  ),
                  title: Text(
                    "Dieto's birthday party",
                    style: regularTextStyle,
                  ),
                  subtitle: Text(
                    "Date: 21/02/2026,  Place: Biłgoraj,  People: 15",
                    style: hintTextStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white, size: 45),
      ),
    );
  }
}
