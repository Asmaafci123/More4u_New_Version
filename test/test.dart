import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more4u/data/models/benefit_model.dart';
import 'package:more4u/data/models/category-model.dart';
import 'package:more4u/data/models/login_response_model.dart';
import 'package:more4u/data/models/benefit_request_model.dart';
import 'package:more4u/data/models/medical-response-model.dart';
import 'package:more4u/data/models/user_model.dart';
import 'package:more4u/domain/entities/category.dart';
import 'package:more4u/domain/entities/medical-response.dart';
import 'package:more4u/myApp.dart';

import 'helpers/json_reader.dart';

main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });


    test(
      'test MyBenefitRequestModel',
      () {
        final Map<String, dynamic> jsonMap = json.decode(
            readJson('helpers/dummy_responses/my_benefit_requests.json'));
        final result = BenefitRequestModel.fromJson(jsonMap['data'][0]);
        var j = result.toJson();
      },
    );

  test(
    'string to date',
    () {
      String birthday = "2021-12-01T00:00:00";
    },
  );
  test('medical',()async{
    String response =
        await rootBundle.loadString('assets/endpoints/medical.json');
    var json = jsonDecode(response);
    List<CategoryModel>cat=[];
    for (var benefit in json['category']) {
      cat.add(CategoryModel.fromJson(benefit));
    }
  });
}
