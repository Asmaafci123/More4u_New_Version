import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? categoryName;
  final String? categoryImage;
  final String? subCategoryImage;
  final String? subCategoryName;
  const Category(
      {this.categoryName,
      this.categoryImage,
      this.subCategoryImage,
      this.subCategoryName,});

  @override
  List<Object?> get props => [
        categoryName,
        categoryImage,
        subCategoryImage,
        subCategoryName,
      ];
}
