import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/domain/usecases/get_benefit_details.dart';

import '../../../domain/entities/benefit.dart';

part 'benefit_details_state.dart';

class BenefitDetailsCubit extends Cubit<BenefitDetailsState> {
  final GetBenefitDetailsUsecase getBenefitDetailsUsecase;

  Benefit? benefit;

  BenefitDetailsCubit({required this.getBenefitDetailsUsecase})
      : super(BenefitDetailsInitial());

  getBenefitDetails(int benefitId) async {
    final result = await getBenefitDetailsUsecase(benefitId: 42);

    result.fold((failure) => emit(BenefitDetailsErrorState()), (benefit) {
      this.benefit = benefit;
      emit(BenefitDetailsSuccessState());
    });
  }
}
