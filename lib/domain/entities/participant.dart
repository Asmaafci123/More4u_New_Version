import 'package:equatable/equatable.dart';

class Participant extends Equatable {
  final int userNumber;
  final String fullName;
  final String? profilePicture;

  const Participant(
      {required this.userNumber,
      required this.fullName,
       this.profilePicture});

  @override
  List<Object?> get props => [userNumber, fullName, profilePicture];
}
