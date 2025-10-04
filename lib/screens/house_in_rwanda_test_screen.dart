import 'package:flutter/material.dart';
import '../services/house_in_rwanda_scraper.dart';
import '../super_base.dart';
import '../constants/theme.dart';

class HouseInRwandaTestScreen extends StatefulWidget {
  const HouseInRwandaTestScreen({super.key});

  @override
  State<HouseInRwandaTestScreen> createState() => _HouseInRwandaTestScreenState();
}

class _HouseInRwandaTestScreenState extends Superbase<HouseInRwandaTestScreen> {
  List<ScrapedProperty> _properties = [];
  bool _isLoading = false;
  String _selectedOfferType = 'rent';
  String? _selectedPropertyType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HouseInRwanda Scraper',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _scrapeProperties,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedOfferType,
                    decoration: const InputDecoration(
                      labelText: 'Offer Type',
                      border: OutlineInputBorder(),
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
                      setState(() {
                        _selectedOfferType = value ?? 'rent';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _selectedPropertyType,
                    decoration: const InputDecoration(
                      labelText: 'Property Type (Optional)',
                      border: OutlineInputBorder(),
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
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _properties.isEmpty
                    ? Center(
                        child: Text(
                          'No properties found. Tap refresh to scrape.',
                          style: TextStyle(
                            fontSize: 16,
                            color: kGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _properties.length,
                        itemBuilder: (context, index) {
                          final property = _properties[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                property.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property.location,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: kGrayDark,
                                    ),
                                  ),
                                                                      Text(
                                      '${property.price.toStringAsFixed(0)} ${property.currency}${property.isMonthly ? '/month' : ''}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                                                      if (property.bedrooms > 0 || property.bathrooms > 0)
                                      Text(
                                        '${property.bedrooms} bed, ${property.bathrooms} bath',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: kGray,
                                        ),
                                      ),
                                                                      if (property.reference.isNotEmpty)
                                      Text(
                                        'Ref: ${property.reference}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: kGray,
                                        ),
                                      ),
                                ],
                              ),
                              trailing: Chip(
                                label: Text(
                                  property.offerType.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: kWhite,
                                  ),
                                ),
                                backgroundColor: property.offerType == 'rent' 
                                    ? Colors.blue.shade600 
                                    : Colors.orange.shade600,
                              ),
                              onTap: () => _showPropertyDetails(property),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrapeProperties,
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<void> _scrapeProperties() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final properties = await HouseInRwandaScraper.scrapeProperties(
        offerType: _selectedOfferType,
        propertyType: _selectedPropertyType,
      );

      setState(() {
        _properties = properties;
        _isLoading = false;
      });

      if (properties.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Scraped ${properties.length} properties from HouseInRwanda')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ No properties found')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }

  void _showPropertyDetails(ScrapedProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          property.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Price: ${property.price.toStringAsFixed(0)} ${property.currency}${property.isMonthly ? '/month' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${property.location}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Bedrooms: ${property.bedrooms}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Bathrooms: ${property.bathrooms}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Reference: ${property.reference}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Offer Type: ${property.offerType.toUpperCase()}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Scraped: ${property.scrapedAt.toString()}',
                style: const TextStyle(fontSize: 12, color: kGray),
              ),
              const SizedBox(height: 16),
              Text(
                'Details:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                property.details,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openPropertyUrl(property.url);
            },
            child: const Text('View Original'),
          ),
        ],
      ),
    );
  }

  void _openPropertyUrl(String url) {
    // You can implement URL launching here
    print('Opening: $url');
  }
}
