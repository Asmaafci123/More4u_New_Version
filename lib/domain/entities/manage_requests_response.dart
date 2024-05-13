import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
class ManageRequestsResponse extends Equatable {
  final List<BenefitRequest>? requests;
  final List<Department>? departments;

  const ManageRequestsResponse({
    this.requests,
    this.departments,
  });

  @override
  List<Object?> get props => [
        requests,
        departments,
      ];
}

class Department extends Equatable {
  final int? id;
  final String? name;

  const Department({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
