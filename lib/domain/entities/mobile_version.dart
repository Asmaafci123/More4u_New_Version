import 'package:equatable/equatable.dart';

class MobileVersion extends Equatable {
  final String message;
  final VersionData data;

  const MobileVersion({required this.message, required this.data});

  @override
  List<Object> get props => [message, data];
}

class VersionData extends Equatable {
  final String? androidVersion;
  final String? iosVersion;
  final String? androidLink;
  final String? iosLink;
  final String? createdDate;

  const VersionData({this.androidVersion,
    this.iosVersion,
    this.androidLink,
    this.iosLink,
    this.createdDate});

  @override
  List<Object?> get props =>
      [androidVersion, iosVersion, androidLink, iosLink, createdDate,];
}
