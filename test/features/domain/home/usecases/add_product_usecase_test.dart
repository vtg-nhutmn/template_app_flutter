import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/home/repositories/product_repository.dart';
import 'package:demo/features/domain/home/usecases/add_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepository;
  late AddProductUseCase useCase;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = AddProductUseCase(mockRepository);
  });

  const tParams = AddProductParams(
    name: 'New Product',
    description: 'A great product',
    price: 99.99,
  );

  group('AddProductUseCase', () {
    test('returns void on successful add', () async {
      when(
        () => mockRepository.addProduct(
          name: any(named: 'name'),
          description: any(named: 'description'),
          price: any(named: 'price'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result.isRight(), isTrue);
      verify(
        () => mockRepository.addProduct(
          name: tParams.name,
          description: tParams.description,
          price: tParams.price,
          imageFile: tParams.imageFile,
        ),
      ).called(1);
    });

    test('returns ServerFailure when repository fails', () async {
      const failure = ServerFailure(message: 'Thêm sản phẩm thất bại');
      when(
        () => mockRepository.addProduct(
          name: any(named: 'name'),
          description: any(named: 'description'),
          price: any(named: 'price'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result, left(failure));
    });

    test('delegates all params to repository', () async {
      when(
        () => mockRepository.addProduct(
          name: 'New Product',
          description: 'A great product',
          price: 99.99,
          imageFile: null,
        ),
      ).thenAnswer((_) async => const Right(null));

      await useCase(tParams);

      verify(
        () => mockRepository.addProduct(
          name: 'New Product',
          description: 'A great product',
          price: 99.99,
          imageFile: null,
        ),
      ).called(1);
    });
  });
}
