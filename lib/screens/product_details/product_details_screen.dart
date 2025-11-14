import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterecommerce/screens/product_details/product_details_services.dart';
import 'package:flutterecommerce/screens/product_details/stars.dart';
import 'package:provider/provider.dart';

import '../../constants/utils.dart';
import '../../models/product.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsServices productDetailsServices = ProductDetailsServices();
  double myRating = 0;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    myRating = _getUserRating();
  }

  double _getUserRating() {
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    for (var rating in widget.product.ratings ?? []) {
      if (rating.userId == userId) {
        return rating.rating;
      }
    }
    return 0;
  }

  bool get isDiscounted {
    if (widget.product.discount?.startDate == null ||
        widget.product.discount?.endDate == null) return false;
    final now = DateTime.now();
    return now.isAfter(widget.product.discount!.startDate!) &&
        now.isBefore(widget.product.discount!.endDate!);
  }

  String _getRemainingTime() {
    if (!isDiscounted) return '';
    final now = DateTime.now();
    final remaining = widget.product.discount!.endDate!.difference(now);

    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours % 24}h';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    }
    return '${remaining.inMinutes}m';
  }

  // Helper method to get valid shop avatar URL
  String _getShopAvatar() {
    final shopAvatar = widget.product.shopAvatar;
    if (shopAvatar == null || shopAvatar.isEmpty) {
      return 'https://via.placeholder.com/40';
    }
    return shopAvatar;
  }

  // Helper method to get valid image URLs for carousel
  List<String> _getValidImages() {
    return widget.product.images.where((image) =>
    image.isNotEmpty && image.startsWith('http')
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final validImages = _getValidImages();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    if (validImages.isNotEmpty)
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 300,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() => _current = index);
                          },
                        ),
                        items: validImages.map((image) {
                          return Builder(
                            builder: (context) => Image.network(
                              image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 300,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Container(
                        height: 300,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Carousel indicators - only show if there are multiple images
                    if (validImages.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: validImages.asMap().entries.map((entry) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(
                                  _current == entry.key ? 0.9 : 0.4,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (isDiscounted)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.redAccent, Colors.red],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.product.discount!.percentage.toStringAsFixed(0)}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Product Details
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Info
                    InkWell(
                      onTap: () {
                        // Add shop navigation here
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: Image.network(
                                  _getShopAvatar(),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.store,
                                      color: Colors.grey,
                                      size: 24,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.shopName ?? 'Shop Name',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Visit Store >',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Product Name
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Rating
                    Row(
                      children: [
                        Stars(rating: widget.product.avgRating ?? 0),
                        const SizedBox(width: 8),
                        Text(
                          '(${widget.product.ratings?.length ?? 0} reviews)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Price Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${widget.product.finalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              if (isDiscounted) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '\$${widget.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (isDiscounted) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Sale ends in: ${_getRemainingTime()}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Stock Info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green[700],
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'In Stock: ${widget.product.quantity}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Rating Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate This Product',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: RatingBar.builder(
                              initialRating: myRating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 28,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                productDetailsServices.rateProduct(
                                  context: context,
                                  product: widget.product,
                                  rating: rating,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Add to Cart',
                function: () {
                  productDetailsServices.addToCart(
                    context: context,
                    product: widget.product,
                  );
                  showSnackBar(context, 'Added to Cart successfully!');
                },
                color: Colors.white,
                textColor: Colors.blue[700]!,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Buy Now',
                function: () {
                  // Add buy now functionality
                },
                color: Colors.blue[700]!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}