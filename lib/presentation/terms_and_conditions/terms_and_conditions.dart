import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/app_strings.dart';
import '../../core/constants/constants.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import '../widgets/utils/message_dialog.dart';
import 'cubits/terms_and_conditions_cubit.dart';

class TermsAndConditions extends StatefulWidget {
  static const routeName = 'TermsAndConditions';
  final  bool isLogin;

  const TermsAndConditions({Key? key,required this.isLogin}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  void initState()
  {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await TermsAndConditionsCubit.get(context).getTermsAndConditions();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TermsAndConditionsCubit,TermsAndConditionsState>(
      listener: (context, state) {
        if (state is GetTermsAndConditionsLoading) {
          loadingAlertDialog(context);
        }
        if (state is GetTermsAndConditionsFail) {
          Navigator.pop(context);
          showMessageDialog(
            context: context,
            isSucceeded: true,
            message: state.message,
          );
        }
        if (state is GetTermsAndConditionsSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          drawer: widget.isLogin==false?const DrawerWidget():const SizedBox(),
          appBar: myAppBar( AppStrings.termsAndConditions.tr(),),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isLogin==false?const MyAppBar():const SizedBox(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      AppStrings.termsAndConditions.tr(),
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Joti',
                          color: redColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 5.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              TermsAndConditionsCubit.get(context).termsAndConditions??"",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF2A2727),
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}