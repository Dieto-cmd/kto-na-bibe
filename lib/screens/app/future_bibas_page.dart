import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kto_na_bibe/constants.dart';
import 'package:kto_na_bibe/cubits/user_cubit.dart';
import 'package:kto_na_bibe/screens/app/biba_page.dart';
import 'package:kto_na_bibe/repositories/cloud_repository.dart';
import 'package:kto_na_bibe/cubits/biba_cubit.dart';
import 'package:intl/intl.dart';

class FutureBibasPage extends StatefulWidget {
  const FutureBibasPage({super.key, this.uid});
  final uid;

  @override
  State<FutureBibasPage> createState() => _FutureBibasPageState();
}

class _FutureBibasPageState extends State<FutureBibasPage> {



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        bool noBibas = state.futureBibaList?.isEmpty == true;

        return noBibas
            ? Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: Text(
                    "No incoming bibas as of now",
                    style: regularTextStyle,
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    final userCubit = context.read<UserCubit>();
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        TextEditingController _nameController =
                            TextEditingController();
                        TextEditingController _placeController =
                            TextEditingController();
                        TextEditingController _dateController =
                            TextEditingController();
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "Create new biba",
                            style: regularTextStyle,
                          ),
                          content: Container(
                            height: 190,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _nameController,
                                  style: regularTextStyle,
                                  decoration: textFormFieldDec.copyWith(
                                    hintText: "Enter biba's name",
                                    hintStyle: hintTextStyle,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _placeController,
                                  style: regularTextStyle,
                                  decoration: textFormFieldDec.copyWith(
                                    hintText: "Enter biba's location",
                                    hintStyle: hintTextStyle,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _dateController,
                                  readOnly: true,
                                  style: regularTextStyle,
                                  decoration: textFormFieldDec.copyWith(
                                    hintText: "Select biba's date and time",
                                    hintStyle: hintTextStyle,
                                    suffixIcon: const Icon(
                                      Icons.calendar_month,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.dark(
                                              primary: Colors.amber,
                                              onPrimary: Colors.black,
                                              surface: Colors.black,
                                              onSurface: Colors.white,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );

                                    if (pickedDate != null) {
                                      if (!context.mounted) return;
                                      TimeOfDay?
                                      pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.dark(
                                                    primary: Colors.amber,
                                                    onPrimary: Colors.black,
                                                    surface: Colors.black,
                                                    onSurface: Colors.white,
                                                  ),
                                              textTheme: TextTheme(
                                                titleSmall: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedTime != null) {
                                        DateTime finalDateTime = DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          pickedTime.hour,
                                          pickedTime.minute,
                                        );

                                        String formattedDate = DateFormat(
                                          'dd.MM.yyyy, HH:mm',
                                        ).format(finalDateTime);
                                        setState(() {
                                          _dateController.text = formattedDate;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel", style: regularTextStyle),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                              ),
                              onPressed: () async {
                                try {
                                  DateTime parsedDate = DateFormat(
                                    'dd.MM.yyyy, HH:mm',
                                  ).parse(_dateController.text);
                                  await userCubit.createBiba(
                                    name: _nameController.text,
                                    place: _placeController.text,
                                    date: parsedDate,
                                    hostUid: widget.uid,
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: Colors.black,
                                        title: Text(
                                          "Something went wrong",
                                          style: regularTextStyle,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                            ),
                                            child: Text(
                                              "Ok",
                                              style: regularTextStyle,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text("Create", style: regularTextStyle),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.pink[700],
                  child: Icon(Icons.add, color: Colors.white, size: 45),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.black,
                body: ListView.builder(
                  itemCount: state.futureBibaList?.length ?? 0,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        final userCubit = context.read<UserCubit>();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: userCubit),

                                BlocProvider<BibaCubit>(
                                  create: (context) => BibaCubit(
                                    cloudRepository: CloudFirestore(),
                                    bibaId: state.futureBibaList?[index].bibaId,
                                  ),
                                ),
                              ],

                              child: BibaPage(isNotPastBiba: true,),
                            ),
                          ),
                        );
                      },
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
                              (state.futureBibaList?[index].name ?? "Error"),
                              style: regularTextStyle.copyWith(fontSize: 18),
                            ),
                            subtitle: Text(
                              "${DateFormat("dd.MM.yyyy, HH:mm").format(state.futureBibaList?[index].bibaDate ?? DateTime(0))}\n"
                              "Host: ${state.futureBibaList?[index].hostName},\n"
                              "Place: ${state.futureBibaList?[index].place}\n"
                              "Guests: ${state.futureBibaList?[index].guestsIds?.length ?? 0}",
                              style: hintTextStyle.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    final userCubit = context.read<UserCubit>();
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        TextEditingController _nameController =
                            TextEditingController();
                        TextEditingController _placeController =
                            TextEditingController();
                        TextEditingController _dateController =
                            TextEditingController();
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "Create new biba",
                            style: regularTextStyle,
                          ),
                          content: Container(
                            height: 190,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _nameController,
                                  style: regularTextStyle,
                                  decoration: textFormFieldDec.copyWith(
                                    hintText: "Enter biba's name",
                                    hintStyle: hintTextStyle,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _placeController,
                                  style: regularTextStyle,
                                  decoration: textFormFieldDec.copyWith(
                                    hintText: "Enter biba's location",
                                    hintStyle: hintTextStyle,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _dateController,
                                  readOnly: true,
                                  style: regularTextStyle,
                                  decoration: textFormFieldDec.copyWith(
                                    hintText: "Select biba's date and time",
                                    hintStyle: hintTextStyle,
                                    suffixIcon: const Icon(
                                      Icons.calendar_month,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.dark(
                                              primary: Colors.amber,
                                              onPrimary: Colors.black,
                                              surface: Colors.black,
                                              onSurface: Colors.white,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );

                                    if (pickedDate != null) {
                                      if (!context.mounted) return;
                                      TimeOfDay?
                                      pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.dark(
                                                    primary: Colors.amber,
                                                    onPrimary: Colors.black,
                                                    surface: Colors.black,
                                                    onSurface: Colors.white,
                                                  ),
                                              textTheme: TextTheme(
                                                titleSmall: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedTime != null) {
                                        DateTime finalDateTime = DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          pickedTime.hour,
                                          pickedTime.minute,
                                        );

                                        String formattedDate = DateFormat(
                                          'dd.MM.yyyy, HH:mm',
                                        ).format(finalDateTime);
                                        setState(() {
                                          _dateController.text = formattedDate;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel", style: regularTextStyle),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                              ),
                              onPressed: () async {
                                try {
                                  DateTime parsedDate = DateFormat(
                                    'dd.MM.yyyy, HH:mm',
                                  ).parse(_dateController.text);
                                  await userCubit.createBiba(
                                    name: _nameController.text,
                                    place: _placeController.text,
                                    date: parsedDate,
                                    hostUid: widget.uid,
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: Colors.black,
                                        title: Text(
                                          "Something went wrong",
                                          style: regularTextStyle,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                            ),
                                            child: Text(
                                              "Ok",
                                              style: regularTextStyle,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text("Create", style: regularTextStyle),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.pink[700],
                  child: Icon(Icons.add, color: Colors.white, size: 45),
                ),
              );
      },
    );
  }
}
