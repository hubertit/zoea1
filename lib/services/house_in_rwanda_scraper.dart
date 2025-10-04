import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class HouseInRwandaScraper {
  static const String baseUrl = 'https://www.houseinrwanda.com';
  
  // Property types available on HouseInRwanda
  static const List<String> propertyTypes = [
    'house',
    'apartment', 
    'room',
    'land',
    'commerce',
    'office',
    'warehouse'
  ];

  // Offer types
  static const List<String> offerTypes = [
    'rent',
    'sale',
    'auction',
    'short-rent'
  ];

  /// Scrape properties from HouseInRwanda
  static Future<List<ScrapedProperty>> scrapeProperties({
    String? offerType = 'rent',
    String? propertyType,
    String? location,
    int? maxPrice,
    int? minPrice,
    int? bedrooms,
    int page = 1,
  }) async {
    try {
      // Build the URL based on filters
      String url = '$baseUrl/for-$offerType';
      if (propertyType != null) {
        url = '$baseUrl/$offerType/$propertyType';
      }

      // Add pagination
      if (page > 1) {
        url += '?page=$page';
      }

      print('🔍 Scraping: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
        },
      );

      if (response.statusCode == 200) {
        return _parseProperties(
          response.body, 
          offerType ?? 'rent',
          minPrice: minPrice,
          maxPrice: maxPrice,
          bedrooms: bedrooms,
        );
      } else {
        print('❌ Failed to scrape: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Scraping error: $e');
      return [];
    }
  }

  /// Parse HTML and extract property data
  static List<ScrapedProperty> _parseProperties(
    String html, 
    String offerType, {
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
  }) {
    final document = html_parser.parse(html);
    final properties = <ScrapedProperty>[];

    // Find property cards
    final propertyCards = document.querySelectorAll('.node__content.card');
    
    for (final card in propertyCards) {
      try {
        final property = _parsePropertyCard(card, offerType);
        if (property != null) {
          // Apply filters
          if (_matchesFilters(property, minPrice: minPrice, maxPrice: maxPrice, bedrooms: bedrooms)) {
            properties.add(property);
          }
        }
      } catch (e) {
        print('❌ Error parsing property card: $e');
      }
    }

    print('✅ Scraped ${properties.length} properties (after filtering)');
    return properties;
  }

  /// Check if property matches the given filters
  static bool _matchesFilters(
    ScrapedProperty property, {
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
  }) {
    // Price filter
    if (minPrice != null || maxPrice != null) {
      final price = property.price.toInt();
      if (minPrice != null && price < minPrice) return false;
      if (maxPrice != null && price > maxPrice) return false;
    }

    // Bedrooms filter
    if (bedrooms != null) {
      if (property.bedrooms < bedrooms) return false;
    }

    return true;
  }

  /// Parse individual property card
  static ScrapedProperty? _parsePropertyCard(Element card, String offerType) {
    try {
      // Extract title and link
      final titleElement = card.querySelector('.card-title a, h5.card-title a');
      if (titleElement == null) return null;

      final title = titleElement.text.trim();
      final link = titleElement.attributes['href'] ?? '';
      final fullUrl = link.startsWith('http') ? link : '$baseUrl$link';

      // Extract image URL
      String imageUrl = '';
      // Look for images inside property links first
      final propertyLink = card.querySelector('a[href*="/property/"]');
      if (propertyLink != null) {
        final imageElement = propertyLink.querySelector('img');
        if (imageElement != null) {
          // Try different image attributes
          String? src = imageElement.attributes['src'];
          if (src == null || src.isEmpty) {
            src = imageElement.attributes['data-src']; // Lazy loading
          }
          if (src == null || src.isEmpty) {
            src = imageElement.attributes['data-lazy-src']; // Another lazy loading variant
          }
          
          if (src != null && src.isNotEmpty) {
            // Handle different image URL formats
            if (src.startsWith('http')) {
              imageUrl = src;
            } else if (src.startsWith('/')) {
              // Relative path starting with / - prioritize these over base64
              imageUrl = '$baseUrl$src';
            } else if (src.startsWith('data:')) {
              // Handle base64 images properly
              imageUrl = src;
            } else {
              // Other relative paths
              imageUrl = '$baseUrl/$src';
            }
          }
        }
      }
      
      // Fallback: look for any image in the card
      if (imageUrl.isEmpty) {
        final imageElement = card.querySelector('img');
        if (imageElement != null) {
          String? src = imageElement.attributes['src'];
          if (src == null || src.isEmpty) {
            src = imageElement.attributes['data-src'];
          }
          if (src == null || src.isEmpty) {
            src = imageElement.attributes['data-lazy-src'];
          }
          
          if (src != null && src.isNotEmpty) {
            if (src.startsWith('http')) {
              imageUrl = src;
            } else if (src.startsWith('data:')) {
              // Handle base64 images properly
              imageUrl = src;
            } else if (src.startsWith('/')) {
              imageUrl = '$baseUrl$src';
            } else {
              imageUrl = '$baseUrl/$src';
            }
            print('🖼️ Found image URL: ${imageUrl.length > 100 ? imageUrl.substring(0, 100) + '...' : imageUrl}');
            print('🖼️ Image type: ${imageUrl.startsWith('data:') ? 'Base64' : 'URL'}');
          }
        }
      }

      // Extract price
      final priceElement = card.querySelector('.badge');
      String priceText = '';
      if (priceElement != null) {
        priceText = priceElement.text.trim();
      }

      // Extract location
      final locationElement = card.querySelector('.fa-map-marker-alt');
      String location = '';
      if (locationElement != null && locationElement.parent != null) {
        location = locationElement.parent!.text.trim();
      }

      // Extract property details
      final detailsElement = card.querySelector('.advert-body-main');
      String details = '';
      if (detailsElement != null) {
        details = detailsElement.text.trim();
      }

      // Extract reference number
      String reference = '';
      final refMatch = RegExp(r'Ref: ([A-Z0-9]+)').firstMatch(details);
      if (refMatch != null) {
        reference = refMatch.group(1) ?? '';
      }

      // Extract bedrooms and bathrooms
      int bedrooms = 0;
      int bathrooms = 0;
      final bedroomMatch = RegExp(r'Bedroom:\s*(\d+)').firstMatch(details);
      final bathroomMatch = RegExp(r'Bathrooms:\s*(\d+)').firstMatch(details);
      
      if (bedroomMatch != null) {
        bedrooms = int.tryParse(bedroomMatch.group(1) ?? '0') ?? 0;
      }
      if (bathroomMatch != null) {
        bathrooms = int.tryParse(bathroomMatch.group(1) ?? '0') ?? 0;
      }

      // Parse price
      double price = 0;
      String currency = 'RWF';
      final priceMatch = RegExp(r'([\d,]+)\s*(RWF|USD)').firstMatch(priceText);
      if (priceMatch != null) {
        final priceStr = priceMatch.group(1)?.replaceAll(',', '') ?? '0';
        price = double.tryParse(priceStr) ?? 0;
        currency = priceMatch.group(2) ?? 'RWF';
      }
      
      // Extract additional details
      String plotSize = '';
      String totalFloors = '';
      String furnished = '';
      String expiryDate = '';
      
      final plotMatch = RegExp(r'Plot size:\s*([\d.]+)\s*m²').firstMatch(details);
      if (plotMatch != null) {
        plotSize = '${plotMatch.group(1)} m²';
      }
      
      final floorMatch = RegExp(r'Total floors:\s*(\d+)').firstMatch(details);
      if (floorMatch != null) {
        totalFloors = floorMatch.group(1) ?? '';
      }
      
      final furnishedMatch = RegExp(r'Furnished:\s*(Yes|No)').firstMatch(details);
      if (furnishedMatch != null) {
        furnished = furnishedMatch.group(1) ?? '';
      }
      
      final expiryMatch = RegExp(r'Expiry date:\s*([A-Za-z]+\s+\d+,\s+\d{4})').firstMatch(details);
      if (expiryMatch != null) {
        expiryDate = expiryMatch.group(1) ?? '';
      }

      // Determine if it's monthly or one-time
      bool isMonthly = priceText.toLowerCase().contains('month') || 
                      priceText.toLowerCase().contains('/month');

      return ScrapedProperty(
        title: title,
        price: price,
        currency: currency,
        isMonthly: isMonthly,
        location: location,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        reference: reference,
        url: fullUrl,
        imageUrl: imageUrl,
        offerType: offerType,
        details: details,
        plotSize: plotSize,
        totalFloors: totalFloors,
        furnished: furnished,
        expiryDate: expiryDate,
        scrapedAt: DateTime.now(),
      );
    } catch (e) {
      print('❌ Error parsing property: $e');
      return null;
    }
  }

  /// Get property details from individual property page
  static Future<ScrapedPropertyDetails?> getPropertyDetails(String propertyUrl) async {
    try {
      final response = await http.get(
        Uri.parse(propertyUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        return _parsePropertyDetails(response.body, propertyUrl);
      }
    } catch (e) {
      print('❌ Error getting property details: $e');
    }
    return null;
  }

  /// Parse detailed property page
  static ScrapedPropertyDetails? _parsePropertyDetails(String html, String url) {
    try {
      final document = html_parser.parse(html);
      
      // Extract description
      final descriptionElement = document.querySelector('.property-description');
      String description = '';
      if (descriptionElement != null) {
        description = descriptionElement.text.trim();
      }

      // Extract contact information
      final contactElement = document.querySelector('.contact-info');
      String contactInfo = '';
      if (contactElement != null) {
        contactInfo = contactElement.text.trim();
      }

      // Extract images
      final images = <String>[];
      final imageElements = document.querySelectorAll('.property-images img');
      for (final img in imageElements) {
        final src = img.attributes['src'];
        if (src != null && src.isNotEmpty) {
          images.add(src.startsWith('http') ? src : '$baseUrl$src');
        }
      }

      return ScrapedPropertyDetails(
        description: description,
        contactInfo: contactInfo,
        images: images,
        url: url,
      );
    } catch (e) {
      print('❌ Error parsing property details: $e');
      return null;
    }
  }
}

/// Model for scraped property data
class ScrapedProperty {
  final String title;
  final double price;
  final String currency;
  final bool isMonthly;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final String reference;
  final String url;
  final String imageUrl;
  final String offerType;
  final String details;
  final String plotSize;
  final String totalFloors;
  final String furnished;
  final String expiryDate;
  final DateTime scrapedAt;

  ScrapedProperty({
    required this.title,
    required this.price,
    required this.currency,
    required this.isMonthly,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    required this.reference,
    required this.url,
    required this.imageUrl,
    required this.offerType,
    required this.details,
    required this.plotSize,
    required this.totalFloors,
    required this.furnished,
    required this.expiryDate,
    required this.scrapedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'currency': currency,
      'isMonthly': isMonthly,
      'location': location,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'reference': reference,
      'url': url,
      'imageUrl': imageUrl,
      'offerType': offerType,
      'details': details,
      'plotSize': plotSize,
      'totalFloors': totalFloors,
      'furnished': furnished,
      'expiryDate': expiryDate,
      'scrapedAt': scrapedAt.toIso8601String(),
    };
  }

  factory ScrapedProperty.fromJson(Map<String, dynamic> json) {
    return ScrapedProperty(
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'RWF',
      isMonthly: json['isMonthly'] ?? false,
      location: json['location'] ?? '',
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      reference: json['reference'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      offerType: json['offerType'] ?? '',
      details: json['details'] ?? '',
      plotSize: json['plotSize'] ?? '',
      totalFloors: json['totalFloors'] ?? '',
      furnished: json['furnished'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      scrapedAt: DateTime.parse(json['scrapedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Model for detailed property information
class ScrapedPropertyDetails {
  final String description;
  final String contactInfo;
  final List<String> images;
  final String url;

  ScrapedPropertyDetails({
    required this.description,
    required this.contactInfo,
    required this.images,
    required this.url,
  });
}
