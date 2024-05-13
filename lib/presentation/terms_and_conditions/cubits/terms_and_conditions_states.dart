part of 'terms_and_conditions_cubit.dart';

@immutable
abstract class TermsAndConditionsState {}

class TermsAndConditionsInitial extends TermsAndConditionsState {}
class GetTermsAndConditionsLoading extends TermsAndConditionsState {}
class  GetTermsAndConditionsSuccess extends TermsAndConditionsState {}
class  GetTermsAndConditionsFail extends TermsAndConditionsState {
  final String? message;

  GetTermsAndConditionsFail (this.message);
}


