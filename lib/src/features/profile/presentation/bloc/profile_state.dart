part of 'profile_bloc.dart';

final class ProfileState extends Equatable {
  final Profile? initialForm;
  final Profile? form;
  final AppStatus? status;
  final SubmitStatus submitStatus;
  final Failure? failure;

  const ProfileState({
    this.initialForm = const Profile(),
    this.form = const Profile(),
    this.status = AppStatus.initial,
    this.submitStatus = SubmitStatus.initial,
    this.failure,
  });

  bool get isDirty => initialForm != form;

  ProfileState copyWith({
    Profile? initialForm,
    Profile? form,
    AppStatus? status,
    SubmitStatus? submitStatus,

    Failure? failure,
  }) {
    return ProfileState(
      initialForm: initialForm ?? this.initialForm,
      form: form ?? this.form,
      status: status ?? this.status,
      submitStatus: submitStatus ?? this.submitStatus,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [initialForm, form, status, submitStatus, failure];
}
