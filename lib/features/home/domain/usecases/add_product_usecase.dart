import 'dart:io';

import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../repositories/product_repository.dart';

class AddProductParams extends Equatable {
  final String name;
  final String description;
  final double price;
  final File? imageFile;

  const AddProductParams({
    required this.name,
    required this.description,
    required this.price,
    this.imageFile,
  });

  @override
  List<Object?> get props => [name, description, price, imageFile];
}

class AddProductUseCase implements UseCase<void, AddProductParams> {
  final ProductRepository _repository;

  AddProductUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(AddProductParams params) {
    return _repository.addProduct(
      name: params.name,
      description: params.description,
      price: params.price,
      imageFile: params.imageFile,
    );
  }
}
