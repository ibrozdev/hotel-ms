class HotelService {
  final String id;
  final String serviceName;
  final String? image;
  final double price;
  final String category;
  final String type;
  final String description;
  final String status;
  final int maxCapacity;
  final List<String> amenities;

  HotelService({
    required this.id,
    required this.serviceName,
    this.image,
    required this.price,
    required this.category,
    required this.type,
    required this.description,
    required this.status,
    this.maxCapacity = 2,
    this.amenities = const [],
  });

  factory HotelService.fromJson(Map<String, dynamic> json) {
    return HotelService(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      image: json['image'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Available',
      maxCapacity: json['maxCapacity'] ?? 2,
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serviceName': serviceName,
      'image': image,
      'price': price,
      'category': category,
      'type': type,
      'description': description,
      'status': status,
      'maxCapacity': maxCapacity,
      'amenities': amenities,
    };
  }
}
