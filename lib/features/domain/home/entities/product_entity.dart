import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageData;
  final String createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageData,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageData,
    createdAt,
  ];
}
