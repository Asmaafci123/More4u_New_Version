import '../../domain/entities/profile_and_documents.dart';

class ProfileAndDocumentsModel extends ProfileAndDocuments {
  ProfileAndDocumentsModel({
    String? profilePicture,
    List<String>? documents,
  }) : super(
          profilePicture: profilePicture,
          documents: documents,
        );

  factory ProfileAndDocumentsModel.fromJson(Map<String, dynamic> json) =>
      ProfileAndDocumentsModel(
        profilePicture: json['profilePicture'],
        documents: json['documents']?.cast<String>(),
      );
}
