import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/loader.dart';

import 'infinite_list_controller.dart';

class InfiniteList<T> extends StatefulWidget {
  final String collection;
  final int pageSize;
  final String orderBy;
  final Map<String, dynamic>? filters;
  final bool descending;

  // CollectionGroup ////////
  final bool group;
  //////////////////////////

  final String noItemsText;
  final String? loadingText;

  /// Function to convert a map to an object of type T
  final T Function(Map<String, dynamic> item, String id) fromJson;

  /// Function to convert an object of type T to a map
  final Map<String, dynamic> Function(T object) toJson;

  final Widget Function(T item, int index, FutureOr<void> Function() onRefresh) itemBuilder;

  const InfiniteList({
    super.key,
    required this.collection,
    this.pageSize = 15,
    this.orderBy = "date",
    this.filters,
    this.descending = true,
    this.noItemsText = "No items found",
    this.loadingText,
    this.group = false,
    required this.fromJson,
    required this.toJson,
    required this.itemBuilder,
  });

  @override
  State<InfiniteList<T>> createState() => _InfiniteListState<T>();
}

class _InfiniteListState<T> extends State<InfiniteList<T>> {
  late InfiniteListController<T> controller;

  bool firstTime = true;

  @override
  void initState() {
    super.initState();

    controller = context.read<InfiniteListController<T>>();

    controller.init(
      collection: widget.collection,
      pageSize: widget.pageSize,
      orderBy: widget.orderBy,
      filters: widget.filters,
      descending: widget.descending,
      group: widget.group,
      fromJson: widget.fromJson,
      toJson: widget.toJson,
    );

    if (firstTime) {
      firstTime = false;
      Future.microtask(() {
        controller.fetchData();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller = context.watch<InfiniteListController<T>>();
  }

  @override
  Widget build(BuildContext context) {
    return controller.fetching
        ? const Center(
            child: Loader(
              color: ThemeModel.darkBlue,
            ),
          )
        : controller.data.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info,
                      size: 40,
                      color: ThemeModel.darkGrey,
                    ),
                    const Gap(10),
                    Text(
                      widget.noItemsText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () => controller.refresh(),
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    if (index == controller.data.length) {
                      if (controller.endOfData) {
                        return null;
                      }
                      controller.fetchData();
                      return const Center(
                        child: Loader(
                          color: ThemeModel.darkBlue,
                        ),
                      );
                    }

                    return widget.itemBuilder(controller.data[index], index, controller.refresh);
                  },
                  itemCount: controller.data.length + 1,
                ),
              );
  }
}
