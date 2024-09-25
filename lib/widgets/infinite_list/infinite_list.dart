import 'package:flutter/material.dart';
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

  final String? loadingText;

  /// Function to convert a map to an object of type T
  final T Function(Map<String, dynamic> item, String id) fromJson;

  /// Function to convert an object of type T to a map
  final Map<String, dynamic> Function(T object) toJson;

  final Widget Function(T item, int index) itemBuilder;

  const InfiniteList({
    super.key,
    required this.collection,
    this.pageSize = 15,
    this.orderBy = "date",
    this.filters,
    this.descending = true,
    this.loadingText,
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
      fromJson: widget.fromJson,
      toJson: widget.toJson,
    );

    // Defer state modification to avoid build phase issues
    Future.microtask(() {
      if (firstTime) {
        firstTime = false;
        controller.fetchData();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller = context.watch<InfiniteListController<T>>();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        controller.fetching
            ? SliverToBoxAdapter(
                child: const Center(
                  child: Loader(
                    color: ThemeModel.darkBlue,
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) {
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

                    return widget.itemBuilder(controller.data[index], index);
                  },
                  childCount: controller.data.length + 1,
                ),
              ),
      ],
    );
    // ListView.builder(
    // itemCount: controller.data.length,
    // itemBuilder: (ctx, index) => widget.itemBuilder(controller.data[index], index),
    // );
  }
}
