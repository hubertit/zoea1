import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/theme.dart';
import '../../partial/cover_container.dart';
import 'models/businesses_model.dart';
import 'wigets/rounded_containers.dart';


class WebMobileDetails extends ConsumerStatefulWidget {
  final WebMobileModel businessModel;
  const WebMobileDetails({super.key, required this.businessModel});

  @override
  ConsumerState<WebMobileDetails> createState() => _OpportunityDetailsState();
}

class _OpportunityDetailsState extends ConsumerState<WebMobileDetails> {
  @override
  Widget build(BuildContext context) {
    var businessModel = widget.businessModel;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        centerTitle: true,
        title: Text(widget.businessModel.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CoverContainer(children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: scaffoldColor,
                    radius: 27,
                    child: CachedNetworkImage(
                      imageUrl: businessModel.logo,
                      height: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(businessModel.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                        Wrap(
                          children: List.generate(
                              businessModel.types.length,
                                  (index) => roundedContainer(
                                  businessModel.types[index].name, () {})),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ]),

            CoverContainer(children: [
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(businessModel.description),


            ]),

          ],
        ),
      ),
    );
  }
}

Widget address(String attr, String vle) {
  return Row(
    children: [
      SizedBox(
        width: 80,
        child: Text(
          attr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      Text(
        vle,
        style: const TextStyle(fontSize: 12),
      )
    ],
  );
}
