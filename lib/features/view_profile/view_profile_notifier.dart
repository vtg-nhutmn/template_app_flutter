import 'package:flutter/foundation.dart';

import 'view_profile_repository.dart';
import 'view_profile_state.dart';

class ViewProfileNotifier extends ChangeNotifier {
  final ViewProfileRepository _repository;

  ViewProfileNotifier({ViewProfileRepository? repository})
    : _repository = repository ?? ViewProfileRepository();

  ViewProfileState _state = const ViewProfileState();
  ViewProfileState get state => _state;

  Future<void> loadProfile() async {
    _state = _state.copyWith(status: ViewProfileStatus.loading);
    notifyListeners();

    try {
      final profile = await _repository.fetchProfile();
      _state = _state.copyWith(
        status: ViewProfileStatus.success,
        profile: profile,
      );
    } on Exception catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      _state = _state.copyWith(
        status: ViewProfileStatus.failure,
        errorMessage: message,
      );
    }
    notifyListeners();
  }
}
