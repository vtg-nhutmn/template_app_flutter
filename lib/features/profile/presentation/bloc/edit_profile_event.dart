import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class EditProfileSubmitted extends EditProfileEvent {
  final String displayName;
  final String phone;
  final String email;

  const EditProfileSubmitted({
    required this.displayName,
    required this.phone,
    required this.email,
  });

  @override
  List<Object?> get props => [displayName, phone, email];
}

class ChangePasswordSubmitted extends EditProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
