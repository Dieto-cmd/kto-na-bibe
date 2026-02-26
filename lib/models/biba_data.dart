import 'package:flutter/material.dart';

class BibaData {
  String? hostId;
  String? hostName;
  Color? hostBackgroundColor;
  List<String?>? guestsIds;
  List<String?>? guestNames;
  List<Color?>? guestsBackgroundColors;
  String? name;
  String? place;
  String? bibaId;

  BibaData({
    this.guestsIds,
    this.hostId,
    this.name,
    this.place,
    this.guestNames,
    this.hostName,
    this.bibaId,
    this.guestsBackgroundColors,
    this.hostBackgroundColor,
  });
}
