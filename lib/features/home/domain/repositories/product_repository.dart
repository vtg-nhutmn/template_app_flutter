import 'dart:io';

import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/home/domain/entities/product_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, void>> addProduct({
    required String name,
    required String description,
    required double price,
    File? imageFile,
  });
}
