part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}


class GetNotificationsLoadingState extends NotificationState {}
class GetNotificationsSuccessState extends NotificationState {}
class GetNotificationsErrorState extends NotificationState {
  final String message;
  GetNotificationsErrorState(this.message);
}

