import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String accessToken;

  const UserEntity({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}
