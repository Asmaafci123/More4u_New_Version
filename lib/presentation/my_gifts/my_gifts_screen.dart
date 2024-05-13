import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';

import '../../core/constants/app_strings.dart';
import '../../core/constants/constants.dart';
import '../../domain/entities/gift.dart';
import '../../injection_container.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import 'cubits/my_gifts_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;
class MyGiftsScreen extends StatefulWidget {
  static const routeName = 'MyGiftsScreen';
  final int requestNumber;

  const MyGiftsScreen({Key? key, this.requestNumber = -1}) : super(key: key);

  @override
  State<MyGiftsScreen> createState() => _MyGiftsScreenState();
}

class _MyGiftsScreenState extends State<MyGiftsScreen> {
  late MyGiftsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<MyGiftsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getMyGifts(requestNumber: widget.requestNumber);
    });
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(context.locale.languageCode=='ar')
    {
      timeago.setLocaleMessages('ar', ArMessages());
    }
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is GetMyGiftsLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is GetMyGiftsSuccessState) {
          Navigator.pop(context);
        }
        if (state is GetMyGiftsErrorState) {
          Navigator.pop(context);
          if(state.message==AppStrings.sessionHasBeenExpired.tr())
          {
            showMessageDialog(
                context: context, isSucceeded: false, message: state.message,
                onPressedOk: ()
                {
                  logOut(context);
                });
          }
          else
          {
            showMessageDialog(
                context: context, isSucceeded: false, message: state.message);
          }

        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: myAppBar(AppStrings.myGifts.tr()),
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyAppBar(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      AppStrings.myGifts.tr(),
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Joti',
                          color: redColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Expanded(
                    child: _cubit.myGifts.isNotEmpty
                        ? RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.anywhere,
                            onRefresh: () async {
                              _cubit.getMyGifts(
                                  requestNumber: widget.requestNumber);
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) =>
                                  myGiftCard(gift: _cubit.myGifts[index]),
                              itemCount: _cubit.myGifts.length,
                            ),
                          )
                        :RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        onRefresh: () async {
                          _cubit.getMyGifts(
                              requestNumber: widget.requestNumber);
                        },
                        child: LayoutBuilder(
                            builder:  (context,constraints){
                              return SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: constraints.maxHeight,
                                      child: Center(child: Text(AppStrings.noGifts.tr(),style: TextStyle(fontSize: 14.sp),))));
                            }, )
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

  Widget myGiftCard({required Gift gift}) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 5.0.w, color: mainColor),
            right: BorderSide(
              width: 2.0.w,
              color: Color(0xFFE7E7E7),
            ),
          ),
        ),
        child: SizedBox(
          height: 130.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                gift.benefitCard!,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/more4u_card.png',
                    fit: BoxFit.fill),
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 9.w,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gift.benefitName ?? '',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 14.sp,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      timeago.format(DateTime.parse(gift.date ?? ''),locale: context.locale.languageCode),
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12.sp,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    AutoSizeText.rich(
                      maxLines: 1,
                      TextSpan(children: [
                        TextSpan(
                          text: '${AppStrings.from.tr()}: ',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              color: greyColor,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: gift.userName ?? '',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            color: greyColor,
                          ),
                        ),
                      ]),
                    ),
                    AutoSizeText.rich(
                      maxLines: 2,
                      TextSpan(children: [
                        TextSpan(
                          text: '${AppStrings.department.tr()}:  ',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              color: greyColor,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: gift.userDepartment.toString(),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10.sp,
                            color: greyColor,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
