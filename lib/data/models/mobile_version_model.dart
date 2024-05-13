import '../../domain/entities/mobile_version.dart';

class MobileVersionModel extends MobileVersion {
  MobileVersionModel({required super.message, required super.data});

  factory MobileVersionModel.fromJson(Map<String, dynamic> json) =>
      MobileVersionModel(
        message: json['message'],
        data: VersionDataModel.fromJson(json['data']),
      );
}

class VersionDataModel extends VersionData {
  const VersionDataModel({
    super.androidVersion,
    super.iosVersion,
    super.androidLink,
    super.iosLink,
    super.createdDate,
  });

  factory VersionDataModel.fromJson(Map<String, dynamic> json) =>
      VersionDataModel(
        androidVersion: json['androidVersion'],
        iosVersion: json['iosVersion'],
        androidLink: json['androidLink'],
        iosLink: json['iosLink'],
        createdDate: json['createdDate'],
      );
}
