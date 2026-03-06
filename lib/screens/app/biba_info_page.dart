import 'package:flutter/material.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BibaInfoPage extends StatelessWidget {
  const BibaInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibaCubit, BibaCubitState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Date: ${DateFormat("dd.MM.yyyy, HH:mm").format(state.data?.bibaDate ?? DateTime(0))}",
                style: regularTextStyle.copyWith(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                "Place: ${state.data?.place}",
                style: regularTextStyle.copyWith(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                "Host: ${state.data?.hostName}",
                style: regularTextStyle.copyWith(fontSize: 15),
              ),
              SizedBox(height: 10),
              Text(
                "Guest count: ${(state.data?.guestNames?.length ?? 0) + 1}",
                style: regularTextStyle.copyWith(fontSize: 15),
              ),
            ],
          ),
        );
      },
    );
  }
}
