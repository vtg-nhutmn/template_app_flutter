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
