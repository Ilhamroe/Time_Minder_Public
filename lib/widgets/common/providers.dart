import 'package:flutter/material.dart';

class SelectedItemsProvider extends ChangeNotifier {
  List<int> _selectedItems = [];

  List<int> get selectedItems => _selectedItems;

  void updateSelectedItems(List<int> newSelectedItems) {
    _selectedItems = newSelectedItems;
    notifyListeners();
  }

  // Method untuk menambahkan indeks ke daftar item yang dipilih
  void addToSelectedItems(int index) {
    if (!_selectedItems.contains(index)) {
      _selectedItems.add(index);
      notifyListeners();
    }
  }

  // Method untuk menghapus indeks dari daftar item yang dipilih
  void removeFromSelectedItems(int index) {
    if (_selectedItems.contains(index)) {
      _selectedItems.remove(index);
      notifyListeners();
    }
  }
}
