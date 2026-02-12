class BibaData {
  String? hostId;
  List<String?>? guestsIds;

  List<Item>? items;

  BibaData({this.guestsIds, this.hostId, this.items});
}

class Item {
  String? boundUserUid;
  String? itemName;
  String? itemId;
  Item({this.boundUserUid, this.itemName, this.itemId});
}
