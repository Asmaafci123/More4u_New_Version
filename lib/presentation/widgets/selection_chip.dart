import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/constants.dart';

class SelectionChip extends StatelessWidget {
  final String label;
  final int index, selectedIndex;
  final void Function(int index) selectIndex;

  const SelectionChip({
    Key? key,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.selectIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ChoiceChip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: selectedIndex == index
                ? BorderSide(color: mainColor)
                : BorderSide(color: Color(0xFFC1C1C1)),
          ),
          backgroundColor: Colors.transparent,
          selectedColor: Color(0xFFE7E7E7),
          label: Text(label),
          labelStyle: TextStyle(
              color: mainColor, fontWeight: FontWeight.bold, fontSize: 13.sp),
          selected: selectedIndex == index,
          onSelected: (bool){
            if(bool) {
              selectIndex(index);
            } else{
              selectIndex(-1);
            }
          }),
    );
  }
}
