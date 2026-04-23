import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final String displayName;
  final String phone;

  const RegisterSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.displayName,
    required this.phone,
  });

  @override
  List<Object?> get props => [username, email, password, displayName, phone];
}
