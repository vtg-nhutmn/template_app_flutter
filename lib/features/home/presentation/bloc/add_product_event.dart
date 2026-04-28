import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object?> get props => [];
}

class AddProductSubmitted extends AddProductEvent {
  final String name;
  final String description;
  final double price;
  final File? imageFile;

  const AddProductSubmitted({
    required this.name,
    required this.description,
    required this.price,
    this.imageFile,
  });

  @override
  List<Object?> get props => [name, description, price, imageFile];
}
