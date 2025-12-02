import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_example/src/core/enums/enums.dart';
import 'package:forms_example/src/core/failure/failure.dart';
import 'package:forms_example/src/features/profile/domain/entity/profile.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<ProfileFormInitialized>(_initialize);
    on<ProfileFormUpdated>(_update);
    on<ProfileFormResetted>(_reset);
    on<ProfileSubmitted>(_submit);
  }

  Future<void> _initialize(
    ProfileFormInitialized event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.isUpdate) {
      emit(state.copyWith(status: AppStatus.loading));

      final form = Profile(
        name: 'User',
        address: 'Example Address',
        email: 'example@gmail.com',
      );

      await Future.delayed(Duration(seconds: 3));
      emit(
        state.copyWith(status: AppStatus.loaded, form: form, initialForm: form),
      );
    }
  }

  void _update(ProfileFormUpdated event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        form: state.form?.copyWith(
          name: event.name,
          address: event.address,
          email: event.email,
        ),
      ),
    );
  }

  void _reset(ProfileFormResetted event, Emitter<ProfileState> emit) =>
      emit(state.copyWith(status: AppStatus.initial, form: state.initialForm));

  Future<void> _submit(
    ProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(submitStatus: SubmitStatus.submitting));

    await Future.delayed(Duration(seconds: 3));
    emit(state.copyWith(submitStatus: SubmitStatus.success));
  }
}
