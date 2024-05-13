import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/constants/constants.dart';
import '../../../domain/usecases/get_terms_and_conditions.dart';
part 'terms_and_conditions_states.dart';

class TermsAndConditionsCubit extends Cubit<TermsAndConditionsState> {
  static TermsAndConditionsCubit get(context) => BlocProvider.of(context);

  GetTermsAndConditionsUseCase getTermsAndConditionsUseCase;

  TermsAndConditionsCubit({
  required this.getTermsAndConditionsUseCase
}) : super(TermsAndConditionsInitial());
  String? termsAndConditions;
  getTermsAndConditions() async {
    emit(GetTermsAndConditionsLoading());
    final result = await getTermsAndConditionsUseCase(
        languageCode: languageId!
    );
    result.fold((failure) {
      emit(GetTermsAndConditionsFail(failure.message));
    }, (response) {
      termsAndConditions=response;
      emit(GetTermsAndConditionsSuccess());
    });
  }

}
