part of 'redeem_cubit.dart';

@immutable
abstract class RedeemState {}

class RedeemInitial extends RedeemState {}

class RedeemLoadingState extends RedeemState {}

class RedeemSuccessState extends RedeemState {}
class RedeemErrorState extends RedeemState {
  final String message;
  RedeemErrorState(this.message);
}

class RedeemGetParticipantsSuccessState extends RedeemState {}

class RedeemGetParticipantsErrorState extends RedeemState {
  final String? message;

  RedeemGetParticipantsErrorState(this.message);
}

class DateChangeState extends RedeemState {}

class ParticipantsChangedState extends RedeemState {}

class ErrorValidationState extends RedeemState {}

class ImagePickedSuccessState extends RedeemState {}
class ImageRemoveSuccessState extends RedeemState {}

