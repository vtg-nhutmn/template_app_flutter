import 'dart:io';

import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/home/data/datasources/product_remote_data_source.dart';
import 'package:demo/features/home/domain/entities/product_entity.dart';
import 'package:demo/features/home/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final models = await _dataSource.getProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct({
    required String name,
    required String description,
    required double price,
    File? imageFile,
  }) async {
    try {
      await _dataSource.addProduct(
        name: name,
        description: description,
        price: price,
        imageFile: imageFile,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
