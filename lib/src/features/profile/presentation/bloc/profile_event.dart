part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class ProfileFormInitialized extends ProfileEvent {
  final bool isUpdate;

  ProfileFormInitialized({this.isUpdate = false});
}

class ProfileFormUpdated extends ProfileEvent {
  final String? name;
  final String? email;
  final String? address;

  ProfileFormUpdated({this.name, this.email, this.address});
}

class ProfileFormResetted extends ProfileEvent {}

class ProfileSateUpdated extends ProfileEvent {
  final AppStatus status;

  ProfileSateUpdated({required this.status});
}

class ProfileSubmitted extends ProfileEvent {}
