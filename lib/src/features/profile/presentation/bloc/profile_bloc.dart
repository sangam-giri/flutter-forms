import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_example/src/core/enums/app_status.dart';
import 'package:forms_example/src/features/profile/domain/entity/profile.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<ProfileFormInitialized>(_initialize);
    on<ProfileFormUpdated>(_update);
    on<ProfileFormResetted>(_reset);
    on<ProfileSateUpdated>(_updateStatus);
    on<ProfileSubmitted>(_submit);
  }

  void _initialize(ProfileFormInitialized event, Emitter<ProfileState> emit) {
    if (event.isUpdate) {
      emit(state.copyWith(formStatus: AppStatus.loading));

      final form = Profile(
        name: 'User',
        address: 'Example Address',
        email: 'example@gmail.com',
      );

      Future.delayed(Duration(seconds: 3), () {
        emit(
          state.copyWith(
            formStatus: AppStatus.successful,
            form: form,
            initialForm: form,
          ),
        );
      });
    } else {
      emit(state.copyWith(formStatus: AppStatus.completed));
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

  void _reset(ProfileFormResetted event, Emitter<ProfileState> emit) {
    emit(state.copyWith(form: state.initialForm, toggleAddress: false));
  }

  void _updateStatus(ProfileSateUpdated event, Emitter<ProfileState> emit) {
    emit(state.copyWith(form: state.initialForm, toggleAddress: false));
  }

  void _submit(ProfileSubmitted event, Emitter<ProfileState> emit) {
    emit(state.copyWith(profileStatus: AppStatus.loading));

    Future.delayed(Duration(seconds: 3), () {
      emit(state.copyWith(profileStatus: AppStatus.completed));
    });
  }
}
