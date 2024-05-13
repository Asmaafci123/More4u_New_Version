import 'package:equatable/equatable.dart';

class Privilege extends Equatable {
  final String? name;
  final String? description;
  final int? priority;
  final String? image;

  const Privilege({this.name, this.description, this.priority, this.image});

  @override
  List<Object?> get props => [
    name,
    description,
    priority,
    image,
  ];
}
