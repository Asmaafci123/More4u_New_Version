part of 'my_gifts_cubit.dart';

@immutable
abstract class MyGiftsState {}

class MyGiftsInitial extends MyGiftsState {}

class GetMyGiftsLoadingState extends MyGiftsState {}

class GetMyGiftsSuccessState extends MyGiftsState {}

class GetMyGiftsErrorState extends MyGiftsState{
  final String message;
  GetMyGiftsErrorState(this.message);
}

