import 'package:equatable/equatable.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object?> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final String productName;

  const AddProductSuccess({required this.productName});

  @override
  List<Object?> get props => [productName];
}

class AddProductError extends AddProductState {
  final String message;

  const AddProductError({required this.message});

  @override
  List<Object?> get props => [message];
}
