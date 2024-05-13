import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/domain/usecases/get_notifications.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/notification.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUsecase getNotificationsUsecase;

  static NotificationCubit get(context) => BlocProvider.of(context);

  NotificationCubit({required this.getNotificationsUsecase})
      : super(NotificationInitial());

  List<Notification> notifications = [];

  void getNotifications() async {
    emit(GetNotificationsLoadingState());
    final result =
        await getNotificationsUsecase(
          token:accessToken,
            userNumber: userData!.userNumber,languageCode:languageId!);
    result.fold((failure) {
      emit(GetNotificationsErrorState(failure.message));
    }, (notifications) {
      this.notifications = notifications;
      emit(GetNotificationsSuccessState());
    });
  }
}
