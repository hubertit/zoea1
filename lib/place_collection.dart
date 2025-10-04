import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/json/place.dart';
import 'package:zoea1/partial/place_grid_item.dart';
import 'package:zoea1/search_field.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';

import 'constants/theme.dart';
import 'events_screen.dart';
import 'homepage.dart';
import 'hotel_list_view.dart';
import 'hotels_screen.dart';
import 'json/service.dart';
import 'partial/explore_card.dart';
import 'place_collection_search.dart';
import 'real_estate_search.dart';
import 'real_estate.dart';
import 'search_delegate.dart';
import 'service_detail_screen.dart';

class PlaceCollection extends StatefulWidget {
  final bool isPushed;
  const PlaceCollection({super.key, this.isPushed = false});

  @override
  State<PlaceCollection> createState() => _PlaceCollectionState();
}

class _PlaceCollectionState extends Superbase<PlaceCollection> with TickerProviderStateMixin {
  List<Place> _places = [];
  List<Service> _services = [];
  final _key = GlobalKey<RefreshIndicatorState>();
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadCategories(fromHome: true);
      reload();
      _startAnimations();
    });
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool loading = false;
  void reload() {
    _key.currentState?.show();
  }

  Future<void> loadData() {
    return ajax(
        url: "venues/",
        method: "POST",
        onValue: (object, url) {
          setState(() {
            _places = (object['venues'] as Iterable?)
                    ?.map((e) => Place.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  Future<void> loadCategories({bool fromHome = false}) {
    setState(() {
      loading = true;
    });
    return ajax(
        url: "categories/",
        method: "POST",
        onValue: (obj, url) {
          setState(() {
            _services = (obj['categories'] as Iterable?)
                    ?.map((e) => Service.fromJson(e))
                    .toList() ??
                [];
            loading = false;
            if (fromHome) {
              // showCategoryModal();
            }
          });
        });
  }

  void handleCategory(Service e) {
    if (e.title.toLowerCase().contains('hotel') || e.title.toLowerCase().contains('accommodation')) {
      push(const HotelsScreen());
    } else if (e.title.toLowerCase().contains('event')) {
      push(const EventsScreen(
        id: '6',
        catName: "Events",
      ));
    } else if (e.title.toLowerCase().contains('real estate')) {
      push(const RealEstateScreen());
    } else {
      push(ServiceDetailScreen(service: e));
    }
  }

  // Get category icon based on title
  IconData _getCategoryIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('hotel') || lowerTitle.contains('accommodation')) {
      return Icons.hotel;
    } else if (lowerTitle.contains('restaurant') || lowerTitle.contains('food')) {
      return Icons.restaurant;
    } else if (lowerTitle.contains('event') || lowerTitle.contains('party')) {
      return Icons.event;
    } else if (lowerTitle.contains('shopping') || lowerTitle.contains('mall')) {
      return Icons.shopping_bag;
    } else if (lowerTitle.contains('health') || lowerTitle.contains('medical')) {
      return Icons.local_hospital;
    } else if (lowerTitle.contains('transport') || lowerTitle.contains('travel')) {
      return Icons.directions_car;
    } else if (lowerTitle.contains('entertainment') || lowerTitle.contains('fun')) {
      return Icons.sports_esports;
    } else if (lowerTitle.contains('education') || lowerTitle.contains('school')) {
      return Icons.school;
    } else if (lowerTitle.contains('real estate') || lowerTitle.contains('property')) {
      return Icons.home;
    } else {
      return Icons.explore;
    }
  }

  // Get category color based on title
  Color _getCategoryColor(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('hotel') || lowerTitle.contains('accommodation')) {
      return const Color(0xFF2196F3); // Blue
    } else if (lowerTitle.contains('restaurant') || lowerTitle.contains('food')) {
      return const Color(0xFFFF5722); // Orange
    } else if (lowerTitle.contains('event') || lowerTitle.contains('party')) {
      return const Color(0xFF9C27B0); // Purple
    } else if (lowerTitle.contains('shopping') || lowerTitle.contains('mall')) {
      return const Color(0xFF4CAF50); // Green
    } else if (lowerTitle.contains('health') || lowerTitle.contains('medical')) {
      return const Color(0xFFF44336); // Red
    } else if (lowerTitle.contains('transport') || lowerTitle.contains('travel')) {
      return const Color(0xFFFF9800); // Amber
    } else if (lowerTitle.contains('entertainment') || lowerTitle.contains('fun')) {
      return const Color(0xFFE91E63); // Pink
    } else if (lowerTitle.contains('education') || lowerTitle.contains('school')) {
      return const Color(0xFF607D8B); // Blue Grey
    } else if (lowerTitle.contains('real estate') || lowerTitle.contains('property')) {
      return const Color(0xFF4CAF50); // Green
    } else {
      return const Color(0xFF795548); // Brown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme(context) ? kBlack : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'Explore',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchDemoSearchDelegate((query) {
                        return Theme(
                            data: Theme.of(context),
                            child: PlaceCollectionSearch(query: query));
                      }));
                },
                icon: Icon(
                  Icons.search,
                  color: isDarkTheme(context) ? kWhite : kBlack,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: refleshColor,
        key: _key,
        onRefresh: loadCategories,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            // Header section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover amazing places',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkTheme(context) ? kGray : textsColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Find the best venues, events, and services across Rwanda',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkTheme(context) ? kGray : kGrayAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Categories grid
            loading
                ? _buildLoadingGrid()
                : _buildCategoriesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkTheme(context) ? kGrayDark : kWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with varying height
              Container(
                height: 160 + (index % 3) * 20, // Match the varying heights
                decoration: BoxDecoration(
                  color: kGrayLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 100,
                      decoration: BoxDecoration(
                        color: kGrayLight,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 32,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kGrayLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesGrid() {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        final categoryColor = _getCategoryColor(service.title);
        final categoryIcon = _getCategoryIcon(service.title);
        
        return AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: _buildEnhancedCategoryCard(service, categoryColor, categoryIcon, index),
              ),
            );
          },
        );
      },
    );
  }



  Widget _buildEnhancedCategoryCard(Service service, Color categoryColor, IconData categoryIcon, int index) {
    return Hero(
      tag: 'category_${service.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => handleCategory(service),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkTheme(context) ? kGrayDark : kWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced image section
                Container(
                  width: double.infinity,
                  height: 160 + (index % 3) * 20, // Vary height: 160, 180, 200
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        categoryColor.withOpacity(0.9),
                        categoryColor.withOpacity(0.7),
                        categoryColor.withOpacity(0.5),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background image or pattern
                      if (service.cover.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: service.cover,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    categoryColor.withOpacity(0.8),
                                    categoryColor.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Icon(
                                categoryIcon,
                                size: 48,
                                color: kWhite,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    categoryColor.withOpacity(0.8),
                                    categoryColor.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Icon(
                                categoryIcon,
                                size: 48,
                                color: kWhite,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                categoryColor.withOpacity(0.8),
                                categoryColor.withOpacity(0.6),
                              ],
                            ),
                          ),
                          child: Icon(
                            categoryIcon,
                            size: 48,
                            color: kWhite,
                          ),
                        ),
                      
                      // Enhanced gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.6),
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                        ),
                      ),
                      
                      // Enhanced category icon badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            categoryIcon,
                            size: 22,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      
                      // Category name overlay at bottom
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Enhanced content section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle
                      Text(
                        'Explore ${service.title.toLowerCase()}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkTheme(context) ? kGray : kGrayAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Action button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: categoryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: categoryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Discover',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
