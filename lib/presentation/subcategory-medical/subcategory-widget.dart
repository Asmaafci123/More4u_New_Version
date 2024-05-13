import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/constants.dart';
import '../../data/models/category-model.dart';
import '../../data/models/details-of-medical-model.dart';
import '../doctors/doctor.dart';
import '../home/cubits/home_cubit.dart';
import 'package:badges/badges.dart' as bg;
class SubCategoryWidget extends StatelessWidget {
  final List<CategoryModel> subCategory;
  const SubCategoryWidget({Key? key,required this.subCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) =>GestureDetector(
        onTap: ()
        {
          List<DetailsOfMedicalModel>result=HomeCubit.get(context).getDetailsOfMedical(subCategory[index].categoryName!,subCategory[index].subCategoryName!);
          Navigator.push(context,MaterialPageRoute(builder: (contex)=>Doctors( details: result,title:subCategory[index].subCategoryName!)));
        },
        child:Stack(
          alignment: Alignment.bottomRight,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 0, 10.w,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Image.network(subCategory[index].subCategoryImage!,width: 50.w,),
                  subCategory[index].subCategoryImage!=null?
                          Image.network(
                              subCategory[index].subCategoryImage!,width: 50.w,
                              errorBuilder:(context, error, stackTrace)
                              {
                                return Image.asset('assets/images/Clinics.png',width: 50.w,);
                              }
                          ):Image.asset('assets/images/Clinics.png',width: 50.w,),

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 0, 10.w,0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(subCategory[index].subCategoryName!,
                            style: TextStyle(
                                color:mainColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.fromLTRB(0, 0, 10.w, 10.h),
              child: Icon(Icons.arrow_circle_right_rounded,color: mainColor,size: 25.sp,),
            ),
            Positioned(
                left: 15.w,
                top: 20.h,
                child: bg.Badge(
              showBadge: true,
              ignorePointer: true,
              position: bg.BadgePosition.bottomEnd(),
              badgeColor: redColor,
              padding: const EdgeInsets.all(0),
              badgeContent: Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                height: 25.h,
                width: 25.w,
                child: AutoSizeText(
                  HomeCubit.get(context).getDetailsOfMedical(subCategory[index].categoryName!,subCategory[index].subCategoryName!).length.toString(),
                  maxLines: 1,
                  wrapWords: false,
                  textAlign: TextAlign.center,
                  minFontSize: 9,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ))
          ],
        ),
      ),
      itemCount: subCategory.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2 ),
    );
  }
}
