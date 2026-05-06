import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/data/home/datasources/product_remote_data_source.dart';
import 'package:demo/features/data/home/models/product_model.dart';
import 'package:demo/features/data/home/repositories/product_repository_impl.dart';
import 'package:demo/features/domain/home/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

void main() {
  late MockProductRemoteDataSource mockDataSource;
  late ProductRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(mockDataSource);
  });

  const tProductModel = ProductModel(
    id: 'p1',
    name: 'Widget A',
    description: 'Desc',
    price: 9.99,
    createdAt: '2026-01-01',
  );

  const tProductEntity = ProductEntity(
    id: 'p1',
    name: 'Widget A',
    description: 'Desc',
    price: 9.99,
    createdAt: '2026-01-01',
  );

  group('getProducts', () {
    test('returns list of ProductEntity on success', () async {
      when(
        () => mockDataSource.getProducts(),
      ).thenAnswer((_) async => [tProductModel]);

      final result = await repository.getProducts();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected right'),
        (list) => expect(list, [tProductEntity]),
      );
    });

    test('returns empty list when data source returns empty', () async {
      when(() => mockDataSource.getProducts()).thenAnswer((_) async => []);

      final result = await repository.getProducts();

      result.fold(
        (_) => fail('Expected right'),
        (list) => expect(list, isEmpty),
      );
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(
          () => mockDataSource.getProducts(),
        ).thenThrow(const ServerException(message: 'Không thể tải sản phẩm'));

        final result = await repository.getProducts();

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect((f as ServerFailure).message, 'Không thể tải sản phẩm'),
          (_) => fail('Expected left'),
        );
      },
    );
  });

  group('addProduct', () {
    test('returns void on success', () async {
      when(
        () => mockDataSource.addProduct(
          name: any(named: 'name'),
          description: any(named: 'description'),
          price: any(named: 'price'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.addProduct(
        name: 'Product',
        description: 'Desc',
        price: 10.0,
      );

      expect(result.isRight(), isTrue);
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(
          () => mockDataSource.addProduct(
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            imageFile: any(named: 'imageFile'),
          ),
        ).thenThrow(const ServerException(message: 'Thêm sản phẩm thất bại'));

        final result = await repository.addProduct(
          name: 'Product',
          description: 'Desc',
          price: 10.0,
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect((f as ServerFailure).message, 'Thêm sản phẩm thất bại'),
          (_) => fail('Expected left'),
        );
      },
    );
  });
}
