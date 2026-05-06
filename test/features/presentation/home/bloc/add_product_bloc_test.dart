import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/home/usecases/add_product_usecase.dart';
import 'package:demo/features/presentation/home/bloc/add_product_bloc.dart';
import 'package:demo/features/presentation/home/bloc/add_product_event.dart';
import 'package:demo/features/presentation/home/bloc/add_product_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAddProductUseCase extends Mock implements AddProductUseCase {}

void main() {
  late MockAddProductUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockAddProductUseCase();
    registerFallbackValue(
      const AddProductParams(name: '', description: '', price: 0),
    );
  });

  AddProductBloc buildBloc() => AddProductBloc(mockUseCase);

  const tEvent = AddProductSubmitted(
    name: 'Awesome Product',
    description: 'Very good',
    price: 49.99,
  );

  group('AddProductBloc', () {
    test('initial state is AddProductInitial', () {
      expect(buildBloc().state, isA<AddProductInitial>());
    });

    blocTest<AddProductBloc, AddProductState>(
      'emits [AddProductLoading, AddProductSuccess] on successful add',
      build: buildBloc,
      setUp: () {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<AddProductLoading>(),
        isA<AddProductSuccess>().having(
          (s) => s.productName,
          'productName',
          'Awesome Product',
        ),
      ],
    );

    blocTest<AddProductBloc, AddProductState>(
      'emits [AddProductLoading, AddProductError] when use case fails',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer(
          (_) async =>
              left(const ServerFailure(message: 'Thêm sản phẩm thất bại')),
        );
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<AddProductLoading>(),
        isA<AddProductError>().having(
          (s) => s.message,
          'message',
          'Thêm sản phẩm thất bại',
        ),
      ],
    );

    blocTest<AddProductBloc, AddProductState>(
      'AddProductSuccess carries the correct product name from event',
      build: buildBloc,
      setUp: () {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(
        const AddProductSubmitted(
          name: 'Special Item',
          description: 'Desc',
          price: 1.0,
        ),
      ),
      expect: () => [
        isA<AddProductLoading>(),
        isA<AddProductSuccess>().having(
          (s) => s.productName,
          'productName',
          'Special Item',
        ),
      ],
    );
  });
}
