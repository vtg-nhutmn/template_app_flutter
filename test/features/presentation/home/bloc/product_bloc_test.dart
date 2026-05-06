import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/home/entities/product_entity.dart';
import 'package:demo/features/domain/home/usecases/get_products_usecase.dart';
import 'package:demo/features/presentation/home/bloc/product_bloc.dart';
import 'package:demo/features/presentation/home/bloc/product_event.dart';
import 'package:demo/features/presentation/home/bloc/product_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

void main() {
  late MockGetProductsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetProductsUseCase();
    registerFallbackValue(NoParams());
  });

  ProductBloc buildBloc() => ProductBloc(mockUseCase);

  const tProducts = [
    ProductEntity(
      id: 'p1',
      name: 'Widget A',
      description: 'Desc',
      price: 9.99,
      createdAt: '2026-01-01',
    ),
  ];

  group('ProductBloc', () {
    test('initial state is ProductInitial', () {
      expect(buildBloc().state, isA<ProductInitial>());
    });

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductsLoaded] with products on success',
      build: buildBloc,
      setUp: () {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => right(tProducts));
      },
      act: (bloc) => bloc.add(const ProductsLoadRequested()),
      expect: () => [
        isA<ProductLoading>(),
        isA<ProductsLoaded>().having((s) => s.products, 'products', tProducts),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductsLoaded] with empty list when no products',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => right([]));
      },
      act: (bloc) => bloc.add(const ProductsLoadRequested()),
      expect: () => [
        isA<ProductLoading>(),
        isA<ProductsLoaded>().having((s) => s.products, 'products', isEmpty),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when use case fails',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer(
          (_) async => left(const ServerFailure(message: 'Lỗi tải sản phẩm')),
        );
      },
      act: (bloc) => bloc.add(const ProductsLoadRequested()),
      expect: () => [
        isA<ProductLoading>(),
        isA<ProductError>().having(
          (s) => s.message,
          'message',
          'Lỗi tải sản phẩm',
        ),
      ],
    );
  });
}
