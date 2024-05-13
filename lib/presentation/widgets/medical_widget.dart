import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import '../../core/constants/constants.dart';
import '../../data/models/category-model.dart';
import '../../data/models/details-of-medical-model.dart';
import '../doctors/doctor.dart';
import '../subcategory-medical/subcategory.dart';
import 'package:badges/badges.dart' as bg;
class MedicalWidget extends StatelessWidget {
  const MedicalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CategoryModel>category=HomeCubit.get(context).cat;
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) =>GestureDetector(
        onTap: ()
        {
          List<CategoryModel>result=HomeCubit.get(context).getSubCategory(category[index].categoryName!);
          if(result.length>1) {
            Navigator.pushNamed(context, SubCategory.routeName ,arguments: result);
          } else {
             List<DetailsOfMedicalModel>result=HomeCubit.get(context).getDetailsOfMedical(category[index].categoryName!,category[index].categoryName!);
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Doctors(details: result,title:category[index].categoryName!)));
          }
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                        alignment: Alignment.topLeft,
                        children: [
                      category[index].categoryImage!=null?
                      Image.network(
                        category[index].categoryImage!,width: 50.w,
                        errorBuilder:(context, error, stackTrace)
                          {
                            return Image.asset('assets/images/Clinics.png',width: 50.w,);
                          }
                      ):
                      Image.asset('assets/images/Clinics.png',width: 50.w,),
                    ]),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w,0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(category[index].categoryName!,
                          style: TextStyle(
                              color:mainColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.fromLTRB(0, 0, 15.w, 15.h),
              child: Icon(Icons.arrow_circle_right_rounded,color: mainColor,size: 25.sp,),
            ),
            Positioned(
              left: 15.w,
                top: 20.h,
                child: bg.Badge(
              showBadge: true,
              ignorePointer: true,
              position: bg.BadgePosition.bottomStart(),
              badgeColor: redColor,
              padding: const EdgeInsets.all(0),
              badgeContent: Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                height: 25.h,
                width: 25.w,
                child: AutoSizeText(
                  HomeCubit.get(context).getSubCategory(category[index].categoryName!).length>1?
                  HomeCubit.get(context).getSubCategory(category[index].categoryName!).length.toString():
                  HomeCubit.get(context).getDetailsOfMedical(category[index].categoryName!,category[index].categoryName!).length.toString(),
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
      itemCount: category.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2 ),
    );
  }
}
