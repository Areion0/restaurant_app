import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../firebase/firestore_controller.dart';

class InfiniteListController<T> extends ChangeNotifier {
  void init({
    required String collection,
    required bool group,
    required int pageSize,
    required String orderBy,
    Map<String, dynamic>? filters,
    required bool descending,
    required T Function(Map<String, dynamic>, String id) fromJson,
    required Map<String, dynamic> Function(T object) toJson,
  }) {
    this.collection = collection;
    this.group = group;
    this.pageSize = pageSize;
    this.orderBy = orderBy;
    this.filters = filters;
    this.descending = descending;
    this.fromJson = fromJson;
    this.toJson = toJson;
  }

  late final String collection;
  // CollectionGroup /////////
  late final bool group;
  //////////////////////////
  late final int pageSize;
  late final String orderBy;
  late final Map<String, dynamic>? filters;
  late final bool descending;
  late final T Function(Map<String, dynamic>, String id) fromJson;
  late final Map<String, dynamic> Function(T object) toJson;

  bool _fetching = true;
  bool get fetching => _fetching;
  set fetching(bool value) {
    _fetching = value;
    notifyListeners();
  }

  List<T> _data = [];
  List<T> get data => _data;
  set data(List<T> value) {
    _data = value;
    notifyListeners();
  }

  void addPage(List<T> page) {
    _data.addAll(page);
    Logger().i("Data length: ${_data.length}");
    notifyListeners();
  }

  void clear() {
    _data.clear();
    lastDocument = null;
    endOfData = false;
    notifyListeners();
  }

  bool _endOfData = false;
  bool get endOfData => _endOfData;
  set endOfData(bool value) {
    _endOfData = value;
    notifyListeners();
  }

  DocumentSnapshot? lastDocument;

  Future<void> fetchData() async {
    try {
      List<T> page = await FirestoreController.getCollectionPaginated<T>(
        collection,
        pageSize: pageSize,
        filters: filters ?? {},
        orderBy: orderBy,
        descending: descending,
        startAfter: lastDocument,
        onLastDocumentInPage: (lastDocument) => this.lastDocument = lastDocument,
        group: group,
        fromJson: fromJson,
        toJson: toJson,
      );

      Logger().i("End of data");
      if (page.length < pageSize) {
        endOfData = true;
      }

      addPage(page);
    } catch (e, s) {
      Logger().e(e);
      Logger().e(s);
      endOfData = true;
    } finally {
      fetching = false;
    }
  }

  Future<void> refresh() async {
    clear();
    fetching = true;
    await fetchData();
  }
}
