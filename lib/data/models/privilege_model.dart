import '../../domain/entities/privilege.dart';

class PrivilegeModel extends Privilege {
  const PrivilegeModel({
    String? name,
    String? description,
    int? priority,
    String? image,

  }) : super(
    name: name,
    description: description,
    priority: priority,
    image: image,
  );

  factory PrivilegeModel.fromJson(Map<String, dynamic> json) =>
      PrivilegeModel(
        name: json['name'],
        description: json['description'],
        priority: json['priority'],
        image: json['image'],
      );

}
