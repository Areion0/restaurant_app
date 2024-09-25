import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../firebase/firestore_controller.dart';

class InfiniteListController<T> extends ChangeNotifier {
  //  ChangeNotifierProvider<InfiniteListController<T>> provide(InfiniteList<T> infiniteList) => ChangeNotifierProvider(
  //       create: (_) => InfiniteListController<T>(),
  //       child: infiniteList,
  //     );

  void init({
    required String collection,
    required int pageSize,
    required String orderBy,
    required bool descending,
    required T Function(Map<String, dynamic>, String id) fromJson,
    required Map<String, dynamic> Function(T object) toJson,
  }) {
    this.collection = collection;
    this.pageSize = pageSize;
    this.orderBy = orderBy;
    this.descending = descending;
    this.fromJson = fromJson;
    this.toJson = toJson;
  }

  late final String collection;
  late final int pageSize;
  late final String orderBy;
  late final bool descending;
  late final T Function(Map<String, dynamic>, String id) fromJson;
  late final Map<String, dynamic> Function(T object) toJson;

  bool _fetching = false;
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
    notifyListeners();
  }

  void clear() {
    _data.clear();
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
    fetching = true;

    try {
      var page = await FirestoreController.getCollectionPaginated<T>(
        collection,
        pageSize: pageSize,
        orderBy: orderBy,
        descending: descending,
        startAfter: lastDocument,
        onLastDocumentInPage: (lastDocument) => this.lastDocument = lastDocument,
        fromJson: fromJson,
        toJson: toJson,
      );

      if (page.length < pageSize) {
        endOfData = true;
      }

      addPage(page);
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    } finally {
      fetching = false;
    }
  }
}
