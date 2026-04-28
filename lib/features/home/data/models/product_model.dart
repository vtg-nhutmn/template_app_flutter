import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/home/domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageData;
  final String createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageData,
    required this.createdAt,
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    String createdAtStr = '';
    if (createdAt is Timestamp) {
      createdAtStr = createdAt.toDate().toIso8601String();
    } else if (createdAt != null) {
      createdAtStr = createdAt.toString();
    }

    return ProductModel(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num? ?? 0).toDouble(),
      imageData: data['imageData'] as String?,
      createdAt: createdAtStr,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'price': price,
    'imageData': imageData,
    'createdAt': FieldValue.serverTimestamp(),
  };

  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    description: description,
    price: price,
    imageData: imageData,
    createdAt: createdAt,
  );
}
