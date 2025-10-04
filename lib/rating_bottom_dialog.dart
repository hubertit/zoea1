import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/style_utls.dart';

import 'json/place.dart';

class RatingBottomDialog extends StatefulWidget {
  final Place place;

  const RatingBottomDialog({super.key, required this.place});

  @override
  State<RatingBottomDialog> createState() => _RatingBottomDialogState();
}

class _RatingBottomDialogState extends Superbase<RatingBottomDialog> {
  final _key = GlobalKey<FormState>();
  final _reviewController = TextEditingController();

  bool _loading = false;

  int _rating = 0;

  void submit() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "venues/addReview",
          method: "POST",
          data: FormData.fromMap({
            "venue_id": widget.place.id,
            "rating": _rating,
            "review": _reviewController.text
          }),
          onValue: (obj, url) {
            if (obj['code'] == 200) {
              goBack();
              showMessageSnack(obj);
            }
          });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          padding: const EdgeInsets.all(15)
              .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: goBack, icon: const Icon(Icons.close)),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        "Place Rating",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ))
                  ],
                ),
                FormField(
                    validator: (s) =>
                        _rating <= 0 ? "Rating field is required" : null,
                    builder: (field) {
                      var row = Row(
                        children: [1, 2, 3, 4, 5]
                            .map((e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rating = e;
                                  });
                                },
                                child: Icon(
                                  e > _rating ? Icons.star_border : Icons.star,
                                  size: 35,
                                  color: Colors.yellow.shade700,
                                )))
                            .toList(),
                      );
                      if (field.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            row,
                            Text(
                              field.errorText!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.error),
                            )
                          ],
                        );
                      }
                      return row;
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Your Review",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                      color: scaffoldColor,
                      child: TextFormField(
                        minLines: 5,
                        maxLines: 8,
                        validator: validateRequired,
                        controller: _reviewController,
                        decoration: InputDecoration(
                            hintText: "Optional",
                            border: StyleUtls.commonInputBorder,
                            // Set the text color here
                            filled: true,
                            fillColor:
                                scaffoldColor // Example color (you can use any color you want)
                            ),
                      )),
                ),
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        onPressed: submit,
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(color: Colors.white),
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
