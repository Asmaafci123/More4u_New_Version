import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/constants.dart';
import '../../domain/entities/privilege.dart';


class PrivilegeCard extends StatelessWidget {
  final Privilege privilege;

  const PrivilegeCard({Key? key, required this.privilege}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 2),
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8.r),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 9.0.w, color: mainColor),
            ),

            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r)),
                child: Image.network(
                  privilege.image!,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/images/more4u_card.png'),
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 0),
                child: Text(
                  privilege.name??'',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      color: greyColor),
                ),
              ),
              Divider(
                indent: 16.w,
                endIndent: 16.w,
                color: Colors.black38,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 0),
                child: Text(
                  privilege.description??'',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Roboto',
                      color: greyColor),
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
