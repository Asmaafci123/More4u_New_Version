import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/benefit.dart';
import 'package:more4u/domain/usecases/get_my_benefits.dart';
part 'my_benefits_state.dart';

class MyBenefitsCubit extends Cubit<MyBenefitsState> {
  static MyBenefitsCubit get(context) => BlocProvider.of(context);
  final GetMyBenefitsUsecase getMyBenefitsUsecase;

  MyBenefitsCubit({
    required this.getMyBenefitsUsecase,
  }) : super(MyBenefitsInitial());

  List<Benefit> myAllBenefits = [];
  List<Benefit> myPendingBenefits = [];
  List<Benefit> myInProgressBenefits = [];
  List<Benefit> myApprovedBenefits = [];
  List<Benefit> myRejectedBenefits = [];
  List<Benefit> myBenefitRequests = [];

  getMyBenefits() async {
    emit(GetMyBenefitsLoadingState());
    final result =
        await getMyBenefitsUsecase(userNumber: userData!.userNumber,languageCode:languageId!,token:accessToken);
    result.fold((failure) {
      emit(GetMyBenefitsErrorState(failure.message));
    }, (myBenefits) {

      clearBenefits();
      myAllBenefits = myBenefits;
      for (Benefit benefit in myAllBenefits) {
        if (benefit.lastStatus == 'Pending') {
          myPendingBenefits.add(benefit);
        } else if (benefit.lastStatus == 'InProgress') {
          myInProgressBenefits.add(benefit);
        } else if (benefit.lastStatus == 'Approved') {
          myApprovedBenefits.add(benefit);
        } else {
          myRejectedBenefits.add(benefit);
        }
      }
      emit(GetMyBenefitsSuccessState());
    });
  }

  void clearBenefits() {
    myPendingBenefits.clear();
    myInProgressBenefits.clear();
    myApprovedBenefits.clear();
    myRejectedBenefits.clear();
    myBenefitRequests.clear();
  }
}
