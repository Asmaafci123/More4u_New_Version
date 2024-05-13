import '../../domain/entities/category.dart';
import '../../domain/entities/details-of-medical.dart';
import '../../domain/entities/medical-response.dart';
import 'category-model.dart';
import 'details-of-medical-model.dart';

class MedicalResponseModel extends MedicalResponse{
  const MedicalResponseModel({
     bool? flag,
     String? message,
     List<Category>? category,
     List<Category>? subCategory,
    List<DetailsOfMedical>? medicalDetails,
  }) : super(
    flag: flag,
    message: message,
    category: category,
    subCategory:subCategory,
    medicalDetails: medicalDetails,
  );

  factory MedicalResponseModel.fromJson(Map<String, dynamic> json) =>
      MedicalResponseModel(
        flag: json['flag'],
        message: json['message'],
        category: json['category'] != null
            ? List<CategoryModel>.from(json['category']
            .map((x) => CategoryModel.fromJson(x))
            .toList())
            : null,
        subCategory: json['subCategory'] != null
            ? List<CategoryModel>.from(json['subCategory']
            .map((x) => CategoryModel.fromJson(x))
            .toList())
            : null,
        medicalDetails: json['medicalDetails'] != null
            ? List<DetailsOfMedicalModel>.from(json['medicalDetails']
            .map((x) => DetailsOfMedicalModel.fromJson(x))
            .toList())
            : null,
      );
}