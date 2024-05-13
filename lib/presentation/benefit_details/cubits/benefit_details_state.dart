part of 'benefit_details_cubit.dart';

@immutable
abstract class BenefitDetailsState {}

class BenefitDetailsInitial extends BenefitDetailsState {}

class BenefitDetailsLoadingState extends BenefitDetailsState {}

class BenefitDetailsSuccessState extends BenefitDetailsState {}

class BenefitDetailsErrorState extends BenefitDetailsState {}