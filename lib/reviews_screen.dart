import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/partial/review_item.dart';
import 'package:zoea1/super_base.dart';

import 'json/place.dart';
import 'json/review.dart';

class ReviewsScreen extends StatefulWidget {
  final Place place;
  const ReviewsScreen({super.key, required this.place});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends Superbase<ReviewsScreen> {
  final _key = GlobalKey<RefreshIndicatorState>();
  List<Review> _list = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _key.currentState?.show();
    });
    super.initState();
  }

  Future<void> loadData() {
    return ajax(
        url: "venues/reviews",
        method: "POST",
        data: FormData.fromMap({
          "venue_id": widget.place.id,
        }),
        onValue: (obj, url) {
          setState(() {
            _list = (obj['venues'] as Iterable?)
                    ?.map((e) => Review.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: RefreshIndicator(color: refleshColor,
        key: _key,
        onRefresh: loadData,
        child: ListView.builder(
          itemBuilder: (context, index) {
            var item = _list[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ReviewItem(review: item),
            );
          },
          itemCount: _list.length,
        ),
      ),
    );
  }
}
