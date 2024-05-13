import '../../domain/entities/details-of-medical.dart';

class DetailsOfMedicalModel extends DetailsOfMedical {
  const DetailsOfMedicalModel({
    String? medicalDetailsName,
    String? medicalDetailsAddress,
    String? medicalDetailsMobile,
    String? medicalDetailsWorkingHours,
    String? medicalDetailsImage,
    String? subCategoryName,
    String? subCategoryImage,
    String? categoryName,
    String? categoryImage,
  }) : super(
    medicalDetailsName:medicalDetailsName,
    medicalDetailsAddress:medicalDetailsAddress,
    medicalDetailsMobile:medicalDetailsMobile,
    medicalDetailsWorkingHours:medicalDetailsWorkingHours,
    medicalDetailsImage:medicalDetailsImage,
    subCategoryName:subCategoryName,
    subCategoryImage:subCategoryImage,
    categoryName:categoryName,
    categoryImage:categoryImage
        );

  factory DetailsOfMedicalModel.fromJson(Map<String, dynamic> json) =>
      DetailsOfMedicalModel(
         medicalDetailsName: json['medicalDetailsName'],
        medicalDetailsAddress: json['medicalDetailsAddress'],
        medicalDetailsMobile: json['medicalDetailsMobile'],
        medicalDetailsWorkingHours: json['medicalDetailsWorkingHours'],
        medicalDetailsImage: json['medicalDetailsImage'],
        subCategoryName: json['subCategoryName'],
        subCategoryImage: json['subCategoryImage'],
        categoryName: json['categoryName'],
        categoryImage: json['categoryImage'],
      );
}
