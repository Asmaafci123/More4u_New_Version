import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? userName;
  final String? email;
  final int userNumber;
  final String? positionName;
  final String? departmentName;
  final String birthDate;
  final String joinDate;
  final String? gender;
  final String? maritalStatus;
  final String? entity;
  final String? nationality;
  final String? phoneNumber;
  final String? address;
  final String? collar;
  final int? sapNumber;
  final String? id;
  final String? supervisorName;
  final String? profilePictureAPI;
  final String? workDuration;
  final bool? hasRequests;
  final int? pendingRequestsCount;
  final bool? isTheGroupCreator;
  final bool? isAdmin;
  final bool? hasRoles;


  const User({
    this.userName,
    this.email,
    required this.userNumber,
    this.positionName,
    this.departmentName,
    required this.birthDate,
    required this.joinDate,
    this.gender,
    this.maritalStatus,
    this.entity,
    this.nationality,
    this.phoneNumber,
    this.address,
    this.collar,
    this.sapNumber,
    this.id,
    this.supervisorName,
    this.profilePictureAPI,
    this.workDuration,
    this.hasRequests,
    this.pendingRequestsCount,
    this.isTheGroupCreator,
    this.isAdmin,
    this.hasRoles,
  });

  @override
  List<Object?> get props => [
        userName,
        email,
        userNumber,
        positionName,
        departmentName,
        birthDate,
        joinDate,
        gender,
        maritalStatus,
    entity,
        nationality,
        phoneNumber,
        address,
        collar,
        sapNumber,
        id,
        supervisorName,
        profilePictureAPI,
        workDuration,
        hasRequests,
        pendingRequestsCount,
        isTheGroupCreator,
        isAdmin,
    hasRoles,
      ];
}
