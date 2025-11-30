part of 'profile_bloc.dart';

final class ProfileState extends Equatable {
  final Profile? initialForm;
  final Profile? form;
  final AppStatus? formStatus;
  final bool toggleAddress;
  final AppStatus submitStatus;

  const ProfileState({
    this.initialForm,
    this.form,
    this.formStatus = AppStatus.initial,
    this.submitStatus = AppStatus.initial,
    this.toggleAddress = false,
  });

  bool get isDirty => initialForm != form;

  ProfileState copyWith({
    Profile? initialForm,
    Profile? form,
    AppStatus? formStatus,
    AppStatus? profileStatus,
    AppStatus? submitStatus,
    bool? toggleAddress,
  }) {
    return ProfileState(
      initialForm: initialForm ?? this.initialForm,
      form: form ?? this.form,
      formStatus: formStatus ?? this.formStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      toggleAddress: toggleAddress ?? this.toggleAddress,
    );
  }

  @override
  List<Object?> get props => [
    initialForm,
    form,
    formStatus,
    submitStatus,
    toggleAddress,
  ];
}
