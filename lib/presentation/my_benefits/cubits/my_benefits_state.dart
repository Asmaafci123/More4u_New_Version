part of 'my_benefits_cubit.dart';

@immutable
abstract class MyBenefitsState {}

class MyBenefitsInitial extends MyBenefitsState {}

class GetMyBenefitsLoadingState extends MyBenefitsState {}

class GetMyBenefitsSuccessState extends MyBenefitsState {}

class GetMyBenefitsErrorState extends MyBenefitsState {
  final String message;
  GetMyBenefitsErrorState(this.message);
}

