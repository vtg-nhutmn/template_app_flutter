import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/home/entities/product_entity.dart';
import 'package:demo/features/domain/home/repositories/product_repository.dart';
import 'package:demo/features/domain/home/usecases/get_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepository;
  late GetProductsUseCase useCase;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  const tProducts = [
    ProductEntity(
      id: 'p1',
      name: 'Product 1',
      description: 'Desc 1',
      price: 10.0,
      createdAt: '2026-01-01',
    ),
    ProductEntity(
      id: 'p2',
      name: 'Product 2',
      description: 'Desc 2',
      price: 20.0,
      createdAt: '2026-01-02',
    ),
  ];

  group('GetProductsUseCase', () {
    test('returns list of products on success', () async {
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => right(tProducts));

      final result = await useCase(NoParams());

      expect(result, right(tProducts));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('returns empty list when no products exist', () async {
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => right(<ProductEntity>[]));

      final result = await useCase(NoParams());

      result.fold(
        (_) => fail('Expected right'),
        (list) => expect(list, isEmpty),
      );
    });

    test('returns ServerFailure when repository fails', () async {
      const failure = ServerFailure(message: 'Không thể tải sản phẩm');
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(NoParams());

      expect(result, left(failure));
    });
  });
}
