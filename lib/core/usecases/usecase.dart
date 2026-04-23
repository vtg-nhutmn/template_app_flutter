// ignore_for_file: avoid_types_as_parameter_names

import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
