import 'package:demo/features/home/domain/usecases/add_product_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_product_event.dart';
import 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase _addProductUseCase;

  AddProductBloc(this._addProductUseCase) : super(AddProductInitial()) {
    on<AddProductSubmitted>(_onAddProductSubmitted);
  }

  Future<void> _onAddProductSubmitted(
    AddProductSubmitted event,
    Emitter<AddProductState> emit,
  ) async {
    emit(AddProductLoading());
    final result = await _addProductUseCase(
      AddProductParams(
        name: event.name,
        description: event.description,
        price: event.price,
        imageFile: event.imageFile,
      ),
    );
    result.fold(
      (failure) => emit(AddProductError(message: failure.message)),
      (_) => emit(AddProductSuccess(productName: event.name)),
    );
  }
}
