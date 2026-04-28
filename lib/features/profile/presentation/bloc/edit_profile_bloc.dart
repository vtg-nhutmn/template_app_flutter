import 'package:demo/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;

  EditProfileBloc(this._updateProfileUseCase) : super(EditProfileInitial()) {
    on<EditProfileSubmitted>(_onEditProfileSubmitted);
  }

  Future<void> _onEditProfileSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        displayName: event.displayName,
        phone: event.phone,
        email: event.email,
      ),
    );
    result.fold(
      (failure) => emit(EditProfileFailure(message: failure.message)),
      (_) => emit(
        const EditProfileSuccess(message: 'Cập nhật thông tin thành công'),
      ),
    );
  }
}
