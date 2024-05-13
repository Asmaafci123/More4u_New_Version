part of 'manage_requests_cubit.dart';

@immutable
abstract class ManageRequestsState {}

class ManageRequestsInitial extends ManageRequestsState {}

class GetRequestsToManageLoadingState extends ManageRequestsState {}

class GetRequestsToManageSuccessState extends ManageRequestsState {}

class GetRequestsToManageErrorState extends ManageRequestsState {
  final String message;

  GetRequestsToManageErrorState(this.message);
}

class GetRequestProfileAndDocumentsLoadingState extends ManageRequestsState {}

class GetRequestProfileAndDocumentsSuccessState extends ManageRequestsState {}

class GetRequestProfileAndDocumentsErrorState extends ManageRequestsState {
  final String message;

  GetRequestProfileAndDocumentsErrorState(this.message);
}



class RemoveRequestSuccessState extends ManageRequestsState {}

class AddRequestResponseLoadingState extends ManageRequestsState {}

class AddRequestResponseSuccessState extends ManageRequestsState {
  final String message;

  AddRequestResponseSuccessState(this.message);
}

class AddRequestResponseErrorState extends ManageRequestsState {
  final String message;

  AddRequestResponseErrorState(this.message);
}

class ChangeFiltration extends ManageRequestsState {}
