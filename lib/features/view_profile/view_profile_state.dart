import 'profile_model.dart';

enum ViewProfileStatus { initial, loading, success, failure }

class ViewProfileState {
  final ViewProfileStatus status;
  final ProfileModel? profile;
  final String? errorMessage;

  const ViewProfileState({
    this.status = ViewProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ViewProfileState copyWith({
    ViewProfileStatus? status,
    ProfileModel? profile,
    String? errorMessage,
  }) {
    return ViewProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
