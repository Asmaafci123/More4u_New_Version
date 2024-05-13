import '../../domain/entities/manage_requests_response.dart';
import 'benefit_request_model.dart';

class ManageRequestsResponseModel extends ManageRequestsResponse {
  const ManageRequestsResponseModel(
      {List<BenefitRequestModel>? requests, List<Department>? departments})
      : super(
          requests: requests,
          departments: departments,
        );

  factory ManageRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    return ManageRequestsResponseModel(
        requests: json['data']['requests'] != null
            ? List<BenefitRequestModel>.from(json['data']['requests']
                .map((x) => BenefitRequestModel.fromJson(x))
                .toList())
            : null,

      departments: json['data']['departmentModels'] != null
          ? List<DepartmentModel>.from(json['data']['departmentModels']
          .map((x) => DepartmentModel.fromJson(x))
          .toList())
          : null,
    );


  }
}

class DepartmentModel extends Department {
  const DepartmentModel({
    id,
    name,
  }) : super(id: id, name: name);

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
