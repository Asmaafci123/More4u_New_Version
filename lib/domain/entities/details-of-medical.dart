import 'package:equatable/equatable.dart';

class DetailsOfMedical extends Equatable {
  final String? medicalDetailsName;
  final String? medicalDetailsAddress;
  final String? medicalDetailsMobile;
  final String? medicalDetailsWorkingHours;
  final String? medicalDetailsImage;
  final String? subCategoryName;
  final String? subCategoryImage;
  final String? categoryName;
  final String? categoryImage;
  const DetailsOfMedical(
      {this.medicalDetailsName,
      this.medicalDetailsAddress,
      this.medicalDetailsMobile,
      this.medicalDetailsWorkingHours,
      this.medicalDetailsImage,
      this.subCategoryName,
      this.subCategoryImage,
      this.categoryName,
      this.categoryImage});

  @override
  List<Object?> get props => [
        medicalDetailsName,
        medicalDetailsAddress,
        medicalDetailsMobile,
        medicalDetailsWorkingHours,
        medicalDetailsImage,
        subCategoryName,
        subCategoryImage,
        categoryName,
        categoryImage,
      ];
}
