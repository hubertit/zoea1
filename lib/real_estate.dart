import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/real_estate.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/partial/favorite_place_item.dart';
import 'package:zoea1/partial/place_list_item.dart';
import 'package:zoea1/real_estate_details.dart';
import 'package:zoea1/real_estate_search.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/utils/number_formatter.dart';
import 'package:zoea1/services/house_in_rwanda_scraper.dart';
import 'package:zoea1/partial/safe_cached_network_image.dart';
import 'package:zoea1/screens/property_details_screen.dart';

import 'json/place.dart';
import 'place_detail_screen.dart';

class RealEstateScreen extends StatefulWidget {
  const RealEstateScreen({super.key});

  @override
  State<RealEstateScreen> createState() => _RealEstateScreenState();
}

class _RealEstateScreenState extends Superbase<RealEstateScreen> {
  List<Property> _list = [];
  List<ScrapedProperty> _scrapedProperties = [];
  final _key = GlobalKey<RefreshIndicatorState>();
  bool loading = false;
  bool _useScrapedData = true; // Toggle between API and scraper data
  String _selectedOfferType = 'rent';
  String? _selectedPropertyType;
  String? _selectedBedrooms;
  String? _selectedPriceRange;
  Timer? _timer;
  bool _showFilters = true;

  @override
  void initState() {
    super.initState();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reload();
    });
  }

  void reload() {
    if (_useScrapedData) {
      _scrapeProperties();
    } else {
    _key.currentState?.show();
    }
  }

  Future<void> _scrapeProperties() async {
    setState(() {
      loading = true;
    });

    try {
      // Parse price range if selected
      int? minPrice;
      int? maxPrice;
      if (_selectedPriceRange != null) {
        final parts = _selectedPriceRange!.split('-');
        if (parts.length == 2) {
          minPrice = int.tryParse(parts[0]);
          maxPrice = int.tryParse(parts[1]);
        }
      }

      // Parse bedrooms if selected
      int? bedrooms;
      if (_selectedBedrooms != null) {
        bedrooms = int.tryParse(_selectedBedrooms!);
      }

      final properties = await HouseInRwandaScraper.scrapeProperties(
        offerType: _selectedOfferType,
        propertyType: _selectedPropertyType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        bedrooms: bedrooms,
      );
      
      setState(() {
        _scrapedProperties = properties;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      // Silently handle errors for better UX
      print('❌ Scraping error: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Real Estate",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _useScrapedData = !_useScrapedData;
              });
              reload();
            },
            icon: Icon(_useScrapedData ? Icons.api : Icons.web),
            tooltip: _useScrapedData ? 'Switch to API' : 'Switch to Scraper',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter controls for scraped data
          if (_useScrapedData && _showFilters)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showFilters ? null : 0,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkTheme(context) ? semiBlack : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // First row: Offer Type and Property Type
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedOfferType,
                          decoration: InputDecoration(
                            labelText: 'Offer Type',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade600),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: HouseInRwandaScraper.offerTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedOfferType = value;
                              });
                              _scrapeProperties();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          value: _selectedPropertyType,
                          decoration: InputDecoration(
                            labelText: 'Property Type',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade600),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('All Types'),
                            ),
                            ...HouseInRwandaScraper.propertyTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPropertyType = value;
                            });
                            _scrapeProperties();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Second row: Bedrooms and Price Range
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          value: _selectedBedrooms,
                          decoration: InputDecoration(
                            labelText: 'Bedrooms',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade600),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Any'),
                            ),
                            const DropdownMenuItem(
                              value: '1',
                              child: Text('1+ Bedroom'),
                            ),
                            const DropdownMenuItem(
                              value: '2',
                              child: Text('2+ Bedrooms'),
                            ),
                            const DropdownMenuItem(
                              value: '3',
                              child: Text('3+ Bedrooms'),
                            ),
                            const DropdownMenuItem(
                              value: '4',
                              child: Text('4+ Bedrooms'),
                            ),
                            const DropdownMenuItem(
                              value: '5',
                              child: Text('5+ Bedrooms'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedBedrooms = value;
                            });
                            _scrapeProperties();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          value: _selectedPriceRange,
                          decoration: InputDecoration(
                            labelText: 'Price Range',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade600),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Any Price'),
                            ),
                            const DropdownMenuItem(
                              value: '0-50000',
                              child: Text('Under 50K'),
                            ),
                            const DropdownMenuItem(
                              value: '50000-100000',
                              child: Text('50K - 100K'),
                            ),
                            const DropdownMenuItem(
                              value: '100000-200000',
                              child: Text('100K - 200K'),
                            ),
                            const DropdownMenuItem(
                              value: '200000-500000',
                              child: Text('200K - 500K'),
                            ),
                            const DropdownMenuItem(
                              value: '500000-1000000',
                              child: Text('500K - 1M'),
                            ),
                            const DropdownMenuItem(
                              value: '1000000-999999999',
                              child: Text('Over 1M'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPriceRange = value;
                            });
                            _scrapeProperties();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
                    Expanded(
            child: _useScrapedData
                ? RefreshIndicator(
                    color: refleshColor,
                    key: _key,
                    onRefresh: _scrapeProperties,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification) {
                          if (scrollInfo.scrollDelta! > 0 && _showFilters) {
                            // Scrolling down - hide filters
                            setState(() {
                              _showFilters = false;
                            });
                          } else if (scrollInfo.scrollDelta! < 0 && !_showFilters) {
                            // Scrolling up - show filters
                            setState(() {
                              _showFilters = true;
                            });
                          }
                        }
                        return false;
                      },
                      child: _buildScrapedPropertiesList(),
                    ),
                  )
                : RefreshIndicator(
                    color: refleshColor,
                    key: _key,
                    onRefresh: loadData,
                    child: _buildApiPropertiesList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrapedPropertiesList() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scrapedProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 64,
              color: kGray,
            ),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: TextStyle(
                fontSize: 18,
                color: kGray,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing the filters above',
              style: TextStyle(
                fontSize: 14,
                color: kGray,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemCount: _scrapedProperties.length,
      itemBuilder: (context, index) {
        final property = _scrapedProperties[index];
        return _buildScrapedPropertyCard(property);
      },
    );
  }

  Widget _buildScrapedPropertyCard(ScrapedProperty property) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyDetailsScreen(property: property),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        clipBehavior: Clip.antiAlias,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: isDarkTheme(context) ? semiBlack : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Stack(
                children: [
                  property.imageUrl.isNotEmpty
                      ? SafeCachedNetworkImage(
                          imageUrl: property.imageUrl,
                          width: double.maxFinite,
                          height: 200,
                          fit: BoxFit.cover,
                          contextInfo: 'Real Estate Property',
                        )
                      : Container(
                          width: double.maxFinite,
                          height: 200,
                          color: kGrayLight,
                          child: Icon(
                            Icons.home_outlined,
                            size: 48,
                            color: kGray,
                          ),
                        ),
                  // Offer Type Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kBlack,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        property.offerType.toUpperCase(),
                        style: const TextStyle(
                          color: kWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Property Details
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Location
                  if (property.location.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 16,
                          color: kGray,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            style: TextStyle(
                              color: kGray,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    NumberFormatter.formatRealEstatePriceWithCurrency(property.price, property.currency),
                    style: const TextStyle(
                      color: kBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Property Details
                  Row(
                    children: [
                      if (property.bedrooms > 0) ...[
                        Icon(Icons.bed, size: 16, color: kGray),
                        const SizedBox(width: 4),
                        Text(
                          '${property.bedrooms} bed',
                          style: TextStyle(
                            fontSize: 12,
                            color: kGray,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (property.bathrooms > 0) ...[
                        Icon(Icons.bathroom, size: 16, color: kGray),
                        const SizedBox(width: 4),
                        Text(
                          '${property.bathrooms} bath',
                          style: TextStyle(
                            fontSize: 12,
                            color: kGray,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (property.reference.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Ref: ${property.reference}',
                      style: TextStyle(
                        fontSize: 12,
                        color: kGray,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiPropertiesList() {
        return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemBuilder: (context, index) {
              var item = _list[index];
              return InkWell(
                onTap: () {
                  push(EstateDetailsScreen(property: item));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  clipBehavior: Clip.antiAlias,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: isDarkTheme(context) ? semiBlack : Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 200,
                          width: double.maxFinite,
                          child: Stack(
                            children: [
                              Image.network(
                                "${_list[index].photoUrl}",
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                                    color: Colors.black,
                                    child: Text(
                                      "For ${item.propertyType}",
                                      style: const TextStyle(
                                          color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                trimm(30, item.title),
                                style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                              ),
                            ),
                            Row(
                              children: [
                                if (item.address.isNotEmpty)
                                  const Icon(
                                    Icons.location_pin,
                                    size: 15,
                                  ),
                                if (item.address.isNotEmpty)
                                  Text(
                                    trimm(19, item.address),
                                    style: TextStyle(
                                        color: isDarkTheme(context)
                                            ? null
                                    : smallTextColor,
                              ),
                                  ),
                                if (item.address.isNotEmpty)
                            const SizedBox(width: 10),
                          const Icon(Icons.timer_outlined, size: 13),
                                Text(
                                  "${item.listingDate}",
                                  style: TextStyle(
                              color: isDarkTheme(context)
                                  ? null
                                  : smallTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                                    children: [
                                      Text(
                            "${item.price}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          const Spacer(),
                                        Text(
                            "${item.propertyType}",
                            style: TextStyle(
                              color: isDarkTheme(context)
                                  ? null
                                  : smallTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                    ],
                  ),
                ),
              );
            },
            itemCount: _list.length,
    );
  }



  void _openPropertyUrl(String url) {
    // You can implement URL opening logic here
    print('Opening URL: $url');
  }

  Future<void> loadData() {
    return ajax(
      url: "realestate/filter?address=musanze&type=sale&category=house&rooms=2&priceFrom=100000&priceTo=300000",
      method: "POST",
      onValue: (obj, url) {
        setState(() {
          _list = (obj['properties'] as Iterable?)
                  ?.map((e) => Property.fromJson(e))
                  .toList() ??
              [];
        });
      },
    );
  }
}

class RealEstateFilter {
  final String address;
  final String type;
  final String category;
  final String rooms;
  final String priceFrom;
  final String priceTo;

  RealEstateFilter({
    required this.address,
    required this.type,
    required this.category,
    required this.rooms,
    required this.priceFrom,
    required this.priceTo,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'address': address,
      'type': type,
      'category': category,
      'rooms': rooms,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
    };
  }

  factory RealEstateFilter.fromQueryParams(Map<String, dynamic> params) {
    return RealEstateFilter(
      address: params['address'] ?? '',
      type: params['type'] ?? '',
      category: params['category'] ?? '',
      rooms: params['rooms'] ?? '',
      priceFrom: params['priceFrom'] ?? '',
      priceTo: params['priceTo'] ?? '',
    );
  }
}
