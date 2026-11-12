import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/listing.dart';
import '../theme.dart';

Widget _photo(Listing l, {double? height, double? width, double radius = 0}) {
  final placeholder = Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: l.id.hashCode.isEven
            ? const [Color(0xFF1E3A8A), Color(0xFF14B8A6)]
            : const [Color(0xFF0F766E), Color(0xFF93C5FD)],
      ),
    ),
    child: const Center(
      child: Icon(Icons.home_work_outlined, size: 40, color: Colors.white70),
    ),
  );
  final url = l.imageUrl;
  final child = url == null
      ? placeholder
      : CachedNetworkImage(
          imageUrl: url,
          height: height,
          width: width,
          fit: BoxFit.cover,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => placeholder,
        );
  return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
}

const _shadow = [
  BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
];

/// Big vertical card (horizontal carousel).
class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;
  const ListingCard({super.key, required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _shadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _photo(listing, height: 150, width: 260),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.priceLabel,
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.price)),
                  const SizedBox(height: 4),
                  Text(listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(listing.details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact horizontal card (lists).
class ListingRow extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;
  const ListingRow({super.key, required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _shadow,
        ),
        child: Row(
          children: [
            _photo(listing, height: 88, width: 88, radius: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.priceLabel,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.price)),
                  const SizedBox(height: 4),
                  Text(listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(listing.details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}