import 'package:more4u/domain/entities/participant.dart';

class ParticipantModel extends Participant {
  const ParticipantModel(
      {required int userNumber,
      required String fullName,
       String? profilePicture})
      : super(
            userNumber: userNumber,
            fullName: fullName,
            profilePicture: profilePicture);

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      userNumber: json['userNumber'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'],
    );
  }
}
