import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SafeCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? contextInfo; // For logging which event/place this image belongs to
  final String? eventId;
  final String? eventName;

  const SafeCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.contextInfo,
    this.eventId,
    this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    // Check if URL is valid
    if (imageUrl.isEmpty) {
      _logImageError("Empty URL", contextInfo);
      return _buildErrorWidget(context);
    }
    
    Widget imageWidget;
    
    // Handle base64 images differently
    if (imageUrl.startsWith('data:')) {
      try {
        // Extract the base64 data from the data URL
        final dataUri = Uri.parse(imageUrl);
        final mimeType = dataUri.data?.mimeType ?? 'image/png';
        final bytes = dataUri.data?.contentAsBytes();
        
        if (bytes != null) {
          imageWidget = Image.memory(
            bytes,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              _logImageError("Base64 image error: $error", contextInfo, url: imageUrl);
              return _buildErrorWidget(context);
            },
          );
        } else {
          _logImageError("Invalid base64 data", contextInfo, url: imageUrl);
          return _buildErrorWidget(context);
        }
      } catch (e) {
        _logImageError("Base64 parsing error: $e", contextInfo, url: imageUrl);
        return _buildErrorWidget(context);
      }
    } else {
      // Handle regular network images
            imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, url, error) {
          _logImageError(error.toString(), contextInfo, url: url);
          return _buildErrorWidget(context);
        },
        placeholder: (context, url) {
          return placeholder ?? _buildPlaceholder(context);
        },
      );
    }

    // Apply borderRadius if provided
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

                void _logImageError(String error, String? contextInfo, {String? url}) {
                // Simple console logging for debugging
                print('🖼️ Image Error: $error');
                if (contextInfo != null) {
                  print('📍 Context: $contextInfo');
                }
                if (url != null) {
                  print('🔗 URL: $url');
                }
              }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: errorWidget ?? const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 30,
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
