import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String? name;
  final String? email;
  final String? address;

  const Profile({this.name, this.email, this.address});

  Profile copyWith({String? name, String? email, String? address}) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'address': address};
  }

  @override
  List<Object?> get props => [name, email, address];
}
