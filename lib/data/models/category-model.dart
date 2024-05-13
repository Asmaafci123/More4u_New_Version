import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    String? categoryName,
    String? categoryImage,
    String? subCategoryName,
    String? subCategoryImage,
  }) : super(
    categoryName: categoryName,
    categoryImage: categoryImage,
    subCategoryName: subCategoryName,
    subCategoryImage: subCategoryImage,
  );
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(
        categoryName: json['categoryName'],
        categoryImage: json['categoryImage'],
        subCategoryName: json['subCategoryName'],
        subCategoryImage: json['subCategoryImage'],
      );

}