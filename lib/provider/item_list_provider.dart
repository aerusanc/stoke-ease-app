import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/provider/model/model_item.dart';


class ItemListProvider extends ChangeNotifier {
  List<Item> _itemList = [];

  List<Item> get itemList => _itemList;

  void addItem(Item newItem) {
    _itemList.add(newItem);
    notifyListeners();
  }
  void updateItem(Item oldItem, Item newItem) {
    final index = _itemList.indexOf(oldItem);
    if (index != -1) {
      _itemList[index] = newItem;
      notifyListeners();
    }
  }

  void deleteItem(Item item) {
    _itemList.remove(item);
    notifyListeners();
  }
}

