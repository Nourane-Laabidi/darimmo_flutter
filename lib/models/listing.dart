class Listing {
  final String id;
  final String title;
  final String description;
  final String type; // apartment, house, villa, land, studio, office
  final String transactionType; // sale or rent
  final String city;
  final String address;
  final double price;
  final int surface;
  final int bedrooms;
  final int bathrooms;
  final List<String> images;
  final double? lat;
  final double? lng;
  final String status;

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.transactionType,
    required this.city,
    required this.address,
    required this.price,
    required this.surface,
    required this.bedrooms,
    required this.bathrooms,
    required this.images,
    required this.status,
    this.lat,
    this.lng,
  });

  factory Listing.fromJson(Map<String, dynamic> j) {
    final imgs = (j['images'] as List? ?? [])
        .map((e) => e is Map ? (e['url'] ?? '').toString() : e.toString())
        .where((u) => u.isNotEmpty)
        .toList();
    final loc = j['location'];
    final coords = loc is Map ? loc['coordinates'] : null;
    return Listing(
      id: (j['_id'] ?? j['id']).toString(),
      title: (j['title'] ?? '').toString(),
      description: (j['description'] ?? '').toString(),
      type: (j['type'] ?? '').toString(),
      transactionType: (j['transactionType'] ?? 'sale').toString(),
      city: (j['city'] ?? '').toString(),
      address: (j['address'] ?? '').toString(),
      price: (j['price'] as num?)?.toDouble() ?? 0,
      surface: (j['surface'] as num?)?.toInt() ?? 0,
      bedrooms: (j['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (j['bathrooms'] as num?)?.toInt() ?? 0,
      images: imgs,
      status: (j['status'] ?? 'pending').toString(),
      lng: coords is List && coords.length == 2 ? (coords[0] as num).toDouble() : null,
      lat: coords is List && coords.length == 2 ? (coords[1] as num).toDouble() : null,
    );
  }

  String? get imageUrl => images.isEmpty ? null : images.first;

  String get priceLabel => transactionType == 'rent'
      ? '${_thousands(price)} DT / mois'
      : '${_thousands(price)} DT';

  String get details => '$city · $bedrooms ch · $bathrooms sdb · $surface m²';
}

String _thousands(double v) {
  final s = v.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return buf.toString();
}