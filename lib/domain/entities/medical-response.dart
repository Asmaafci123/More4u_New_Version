import 'package:equatable/equatable.dart';
import 'category.dart';
import 'details-of-medical.dart';
class MedicalResponse extends Equatable {
  final bool? flag;
  final String? message;
  final List<Category>? category;
  final List<Category>? subCategory;
  final List<DetailsOfMedical>? medicalDetails;
  const MedicalResponse({this.flag, this.message, this.category,this.subCategory, this.medicalDetails});

  @override
  List<Object?> get props => [
    flag,
    message,
    category,
    subCategory,
    medicalDetails
  ];
}
