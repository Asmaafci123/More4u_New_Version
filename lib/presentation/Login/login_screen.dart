import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/app_strings.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/custom_icons.dart';
import 'package:more4u/injection_container.dart';
import 'package:more4u/presentation/terms_and_conditions/terms_and_conditions.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import '../home/home_screen.dart';
import '../widgets/powered_by_cemex.dart';
import '../widgets/utils/loading_dialog.dart';
import '../widgets/utils/message_dialog.dart';
import 'cubits/login_cubit.dart';
import 'cubits/login_states.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late LoginCubit _cubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _cubit = sl<LoginCubit>();
    super.initState();
  }

  String? validateEmail(String? value) {
    if (value != null && value.isEmpty) {
      return 'emailError';
    } else {
      return null;
    }
  }

//   validate Password
  String? validatePassword(String? value) {
    if (value != null && value.isEmpty) {
      return 'passwordError';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.locale == const Locale('en')) {
      _cubit.changeAppLanguage('English');
    } else {
      _cubit.changeAppLanguage('Arabic');
    }
    if (context.locale.languageCode == 'ar') {
      timeago.setLocaleMessages('ar', ArMessages());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Center(
              child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/decoration.png',
                    fit: BoxFit.fitWidth,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/more4u_new.png',
                    height: 170.h,
                    width: 180.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BlocConsumer(
                bloc: _cubit, //login cubit
                listener: (context, state) {
                  if (state is LoginLoadingState) loadingAlertDialog(context);
                  if (state is LoginErrorState) {
                    Navigator.pop(context);
                    showMessageDialog(
                      context: context,
                      message: state.message,
                      isSucceeded: false,
                    );
                  }
                  if (state is LoginSuccessState) {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName, (Route<dynamic> route) => false);
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: mainColor,
                            fontSize: 12.sp),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                          suffixIconConstraints:
                          BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
                          prefixIconConstraints:
                          BoxConstraints(minHeight: 20.h, minWidth: 40.w),
                          prefixIcon: Icon(
                            CustomIcons.user_info,
                            size: 20.r,
                          ),
                          border: const OutlineInputBorder(),
                          labelText: AppStrings.userNumber.tr(),
                          labelStyle: TextStyle(fontSize: 14.sp),
                          hintText: AppStrings.enterYourNumber.tr(),
                          hintStyle: TextStyle(
                              color: Color(0xffc1c1c1), fontSize: 12.sp),
                          errorStyle: TextStyle(fontSize: 12.sp),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        keyboardType: TextInputType.number,
                        controller: _cubit.userNumberController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        validator: (String? value) {
                          if (value!.isEmpty) return AppStrings.required.tr();
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      TextFormField(
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: mainColor,
                            fontSize: 12.sp),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                          suffixIconConstraints:
                          BoxConstraints(minHeight: 50.h, minWidth: 50.w),
                          prefixIconConstraints:
                          BoxConstraints(minHeight: 20.h, minWidth: 40.w),
                          prefixIcon: Icon(
                            CustomIcons.lock2,
                            size: 20.r,
                          ),
                          suffixIcon: Material(
                            color: Colors.transparent,
                            type: MaterialType.circle,
                            clipBehavior: Clip.antiAlias,
                            borderOnForeground: true,
                            elevation: 0,
                            child: IconButton(
                              onPressed: () {
                                _cubit.changeTextVisibility(
                                    !_cubit.isTextVisible);
                              },
                              icon: !_cubit.isTextVisible
                                  ? Icon(
                                Icons.visibility_off_outlined,
                                size: 30.r,
                              )
                                  : Icon(
                                Icons.remove_red_eye_outlined,
                                size: 30.r,
                              ),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: AppStrings.password.tr(),
                          hintText: AppStrings.enterYourPassword.tr(),
                          hintStyle: TextStyle(
                              color: Color(0xffc1c1c1), fontSize: 14.sp),
                          labelStyle: TextStyle(
                              color: Color(0xffc1c1c1), fontSize: 12.sp),
                          errorStyle: TextStyle(fontSize: 12.sp),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_cubit.isTextVisible,
                        controller: _cubit.passwordController,
                        validator: (String? value) {
                          if (value!.isEmpty) return AppStrings.required.tr();
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      DropdownButtonFormField(
                        style: TextStyle(color: mainColor, fontSize: 12.sp),
                        validator: (String? value) {
                          if (value == null) return AppStrings.required.tr();
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 8.w),
                          suffixIconConstraints:
                          BoxConstraints(minHeight: 50.h, minWidth: 50.w),
                          prefixIconConstraints:
                          BoxConstraints(minHeight: 20.h, minWidth: 40.w),
                          prefixIcon: Image(
                            image: AssetImage(
                              'assets/images/language.png',
                            ),
                            height: 25.h,
                            fit: BoxFit.contain,
                          ),
                          border: const OutlineInputBorder(),
                          labelText: AppStrings.language.tr(),
                          hintText: AppStrings.enterLanguage.tr(),
                          labelStyle: TextStyle(fontSize: 14.sp),
                          hintStyle: TextStyle(
                              color: Color(0xffc1c1c1), fontSize: 12.sp),
                          errorStyle: TextStyle(fontSize: 12.sp),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        items: ['English', 'Arabic'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value == 'Arabic' ? "عربى" : value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          _cubit.changeAppLanguage(newValue!);
                          if (newValue == 'English') {
                            context.setLocale(const Locale('en'));
                          } else {
                            context.setLocale(const Locale('ar'));
                          }
                        },

                        iconSize: 20.r,
                      ),
                      SizedBox(
                        height: 55.h,
                      ),
                      SizedBox(
                        height: 60.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _cubit.login();
                            }
                          },
                          child: Text(
                            AppStrings.login.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      TextButton(onPressed: (){
                        languageId=context.locale.languageCode=='en'?1:2;
                        Navigator.pushNamed(context, TermsAndConditions.routeName,arguments: true);
                      }, child: Text(AppStrings.termsAndConditions.tr())),
                      const PoweredByCemex()
                    ]),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}