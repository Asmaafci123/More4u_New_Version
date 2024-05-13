import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/data/models/details-of-medical-model.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../widgets/card-of-medical-subCategory.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/app_bar.dart';
import '../widgets/utils/app_bar_medical.dart';

class Doctors extends StatefulWidget {
  final List<DetailsOfMedicalModel> details;
  final String title;
  const Doctors({Key? key,required this.details,required this.title}) : super(key: key);

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  // @override
  // void dispose() {
  //   HomeCubit.get(context).clearSearchController();
  //   super.dispose();
  // }
  @override
  void initState()
  {
    HomeCubit.get(context).clearSearchController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return Scaffold(
        appBar: myAppBarMedicalIos(),
        drawer: const DrawerWidget(),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyAppBar(),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: AutoSizeText(
                          widget.title,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontFamily: 'Joti',
                              color: redColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                        color: Colors.black26)
                                  ]),
                              child: TextField(
                                style: TextStyle(fontSize: 12.sp),
                                controller: HomeCubit.get(context).searchMedicalController ,
                                keyboardType: TextInputType.text,
                                onChanged: (value)
                                {
                                  HomeCubit.get(context).searchInMedical(widget.details,value);
                                },
                                decoration: InputDecoration(
                                  hintText: AppStrings.search.tr(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 11.w),
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: whiteGreyColor),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: whiteGreyColor),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10.r),
                            onTap: () {
                              HomeCubit.get(context).searchInMedical(widget.details,HomeCubit.get(context).searchMedicalController.text);
                            },
                            child: Ink(
                              width: 35.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 10)
                                  ],
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                  child: Icon(
                                    // Icons.filter_list_alt,
                                    CustomIcons.search__1_,
                                    size: 17.r,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      HomeCubit.get(context).searchMedicalController.text.isEmpty?
                      widget.details.isNotEmpty?Expanded(
                          child: ListView.builder(
                              itemBuilder: (context,index)=>WidgetOfSubCategory(obj: widget.details[index],),
                            itemCount: widget.details.length,
                          ),
                      ):Expanded(
                        child: Center(
                          child: Text(AppStrings.thereIsNoData.tr()),
                        ),
                      ):
                      HomeCubit.get(context).resultList.isNotEmpty?Expanded(
                        child: ListView.builder(
                          itemBuilder: (context,index)=>WidgetOfSubCategory(obj:HomeCubit.get(context).resultList[index],),
                          itemCount:  HomeCubit.get(context).resultList.length,
                        ),
                      ):Expanded(
                        child: Center(
                          child: Text(AppStrings.thereIsNoData.tr()),
                        ),
                      )
                    ])

            )
        )
    );
  },
);
  }
}
