import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart'; // For reverse geocoding
import 'package:zoea1/constants/apik.dart';
import 'package:zoea1/services/api_key_manager.dart';

import '../ults/style_utls.dart';

class AddressPickerScreen extends StatefulWidget {
  @override
  _AddressPickerScreenState createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  late GoogleMapController _mapController;
  LatLng? selectedLocation;
  String? selectedAddress;

  final TextEditingController searchController = TextEditingController();
  late GoogleMapsPlaces _places;
  late GoogleMapsGeocoding _geocoding;
  
  @override
  void initState() {
    super.initState();
    _initializeGoogleMaps();
  }
  
  Future<void> _initializeGoogleMaps() async {
    try {
      final apiKey = await ApiKeyManager.getGoogleMapsKey();
      _places = GoogleMapsPlaces(apiKey: apiKey);
      _geocoding = GoogleMapsGeocoding(apiKey: apiKey);
    } catch (e) {
      // Fallback to local key
      _places = GoogleMapsPlaces(apiKey: mapKy);
      _geocoding = GoogleMapsGeocoding(apiKey: mapKy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick an Address'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search for a location (e.g., Kigali)",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchLocation(searchController.text),
                ),
                border:StyleUtls.commonInputBorder,
              ),
              onSubmitted: (value) => _searchLocation(value),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-1.94995, 30.05885), // Default location (Kigali)
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: (position) async {
              setState(() {
                selectedLocation = position;
              });
              await _getAddressFromCoordinates(position);
            },
            markers: selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: selectedLocation!,
                    ),
                  }
                : {},
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                // Pass the selected address back to the previous screen
                Navigator.pop(
                  context,
                  selectedAddress ??
                      '${selectedLocation?.latitude}, ${selectedLocation?.longitude}',
                );
              },
              child: const Text(
                'Confirm Address',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    final response = await _places.searchByText(query);

    if (response.status == "OK" && response.results.isNotEmpty) {
      final place = response.results.first;

      final lat = place.geometry!.location.lat;
      final lng = place.geometry!.location.lng;

      // Move the map to the searched location
      _mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );

      setState(() {
        selectedLocation = LatLng(lat, lng);
        selectedAddress = place.formattedAddress; // Update the selected address
      });
    } else {
      // Show an error if no results are found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No results found for "$query".')),
      );
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng position) async {
    try {
      final response = await _geocoding.searchByLocation(
        Location(lat: position.latitude, lng: position.longitude),
      );

      if (response.status == "OK" && response.results.isNotEmpty) {
        setState(() {
          selectedAddress = response.results.first.formattedAddress;
        });
      } else {
        setState(() {
          selectedAddress = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to fetch address.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching address: $e')),
      );
    }
  }
}
