import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/screens/app/guest_page.dart';
import 'package:kto_na_bibe/screens/app/item_page.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';

class BibaPage extends StatelessWidget {
  const BibaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BibaCubit>(
      create: (_) => BibaCubit(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.pink[700],
            title: Text("Dieto Birthday's party", style: regularTextStyle),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.amber,
              indicatorWeight: 1.0,
              unselectedLabelColor: Colors.grey,
              labelStyle: regularTextStyle.copyWith(fontSize: 16),
              tabs: [
                Tab(text: "Guests"),
                Tab(text: "Items"),
              ],
            ),
          ),
          body: TabBarView(children: [GuestPage(), ItemPage()]),
        ),
      ),
    );
  }
}
