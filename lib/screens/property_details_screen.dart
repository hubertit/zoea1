import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/services/house_in_rwanda_scraper.dart';
import 'package:zoea1/partial/safe_cached_network_image.dart';
import 'package:zoea1/utils/number_formatter.dart';
import 'package:zoea1/ults/functions.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final ScrapedProperty property;

  const PropertyDetailsScreen({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme(context) ? kBlack : kGrayLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkTheme(context) ? kBlack : kWhite,
        title: Text(
          'Property Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkTheme(context) ? kWhite : kBlack,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDarkTheme(context) ? kWhite : kBlack,
        ),
        actions: [
          IconButton(
            onPressed: () => _openPropertyUrl(property.url),
            icon: const Icon(Icons.open_in_new),
            tooltip: 'View on Website',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: kBlack,
        onRefresh: () async {
          // You can implement refresh logic here if needed
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            if (property.imageUrl.isNotEmpty)
              Container(
                height: 250,
                width: double.infinity,
                child: SafeCachedNetworkImage(
                  imageUrl: property.imageUrl,
                  fit: BoxFit.cover,
                  contextInfo: 'Property Details Header',
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                color: kGrayLight,
                child: Icon(
                  Icons.home_outlined,
                  size: 64,
                  color: kGray,
                ),
              ),
            
            // Property Information
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.circular(6),
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
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Price
                  Text(
                    NumberFormatter.formatRealEstatePriceWithCurrency(property.price, property.currency),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                    ),
                  ),
                  
                  if (property.isMonthly)
                    Text(
                      'per month',
                      style: TextStyle(
                        fontSize: 14,
                        color: kGray,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Location
                  if (property.location.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 20,
                          color: kGray,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            property.location,
                            style: TextStyle(
                              fontSize: 16,
                              color: kGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Property Details Section
                  _buildSection(
                    'Property Details',
                    [
                      _buildDetailRow('Bedrooms', '${property.bedrooms}'),
                      _buildDetailRow('Bathrooms', '${property.bathrooms}'),
                      if (property.plotSize.isNotEmpty)
                        _buildDetailRow('Plot Size', property.plotSize),
                      if (property.totalFloors.isNotEmpty)
                        _buildDetailRow('Total Floors', property.totalFloors),
                      if (property.furnished.isNotEmpty)
                        _buildDetailRow('Furnished', property.furnished),
                      if (property.expiryDate.isNotEmpty)
                        _buildDetailRow('Expiry Date', property.expiryDate),
                      if (property.reference.isNotEmpty)
                        _buildDetailRow('Reference', property.reference),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description Section
                  if (property.details.isNotEmpty)
                    _buildSection(
                      'Description',
                      [
                        Text(
                          property.details,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Contact Information Section
                  _buildSection(
                    'Contact Information',
                    [
                      _buildDetailRow('Source', 'HouseInRwanda.com'),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openPropertyUrl(property.url),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('View on Website'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBlack,
                            foregroundColor: kWhite,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareProperty(),
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBlack,
                            foregroundColor: kWhite,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkTheme(context) ? semiBlack : kWhite,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kGray,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPropertyUrl(String url) {
    // You can implement URL opening logic here
    print('Opening URL: $url');
  }

  void _shareProperty() {
    // You can implement sharing logic here
    print('Sharing property: ${property.title}');
  }
}
