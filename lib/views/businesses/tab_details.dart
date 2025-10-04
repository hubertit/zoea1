import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoea1/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/theme.dart';
import '../../partial/cover_container.dart';
import 'models/tech_businesses.dart';
import 'wigets/rounded_containers.dart';


class TabsDetails extends ConsumerStatefulWidget {
  final TechBusinessModel businessModel;
  const TabsDetails({super.key, required this.businessModel});

  @override
  ConsumerState<TabsDetails> createState() => _OpportunityDetailsState();
}

class _OpportunityDetailsState extends ConsumerState<TabsDetails> {
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
        title: Text(widget.businessModel.companyName),
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
                        Text(businessModel.companyName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                        Wrap(
                          runSpacing: 2,
                          children: List.generate(
                              businessModel.sectors.length,
                                  (index) => roundedContainer(
                                  businessModel.sectors[index], () {})),
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
              Text(businessModel.companyDescription),


            ]),
            CoverContainer(children: [
              const Row(
                children: [
                  Text(
                    "Location address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              address("Province: ", businessModel.province),
              address("District: ", businessModel.district),
              address("Sector: ", businessModel.sector),
              address("Cell: ", businessModel.cell),
              address("Village: ", businessModel.village),
            ]),
            CoverContainer(children: [
              const Row(
                children: [
                  Text(
                    "Contact address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              address("Phone: ", businessModel.companyPhone),
              address("Email: ", businessModel.companyEmail),
              Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      "Website: ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: InkWell(onTap: (){
                      launchUrl(Uri.parse(businessModel.website));
                    
                    }, child:                   Text(
                      businessModel.website,
                      style: const TextStyle(fontSize: 12,color: primaryColor),
                    )
                    ),
                  )
                ],
              )
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
