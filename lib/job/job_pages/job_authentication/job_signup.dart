import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_seeker/job/job_gloabelclass/job_color.dart';
import 'package:job_seeker/job/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/job/job_pages/job_authentication/job_otpverificationmail.dart';
import 'package:job_seeker/job/job_pages/job_home/job_dashboard.dart';
import '../../../services/Auth.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_accountsetup/job_selectcountry.dart';
import 'job_login.dart';

class JobSignup extends StatefulWidget {
  const JobSignup({Key? key}) : super(key: key);

  @override
  State<JobSignup> createState() => _JobSignupState();
}

class _JobSignupState extends State<JobSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();

  void submitEmail(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    // Call otpverif method from AuthService
    authService.otpverif(context: context, email: email);

    // Pass the email and password to the Verification Code screen
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return JobOtpverificationMail(email: email, password: password);
    }));
  }

  void signupUser() {
    authService.signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      role:"Candidat"
    );
  }



  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  bool _obscureText2 = true;
  void _togglePasswordStatus2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }
  bool isChecked = true;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return JobColor.appcolor;
    }
    return JobColor.appcolor;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            children: [
              SizedBox(height: height/15,),
              Image.asset(JobPngimage.logo,height: height/8,fit: BoxFit.fitHeight,),
              SizedBox(height: height/26,),
              Text("Create_New_Account".tr,style: urbanistBold.copyWith(fontSize: 30 )),
              SizedBox(height: height/26,),
              TextFormField(
                controller: nameController,
                style: urbanistSemiBold.copyWith(fontSize: 16,),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,),
                  hintText: "Name".tr,
                 fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  prefixIcon:Icon(Icons.person,size: height/46,),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/46,),
              TextFormField(
                controller: emailController,
                style: urbanistSemiBold.copyWith(fontSize: 16,),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,),
                  hintText: "Email".tr,
                 fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  prefixIcon:Icon(Icons.email,size: height/46,),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/46,),

              TextFormField(
                controller: passwordController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,),
                  hintText: "Password".tr,
                 fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText2 ? Icons.visibility_off : Icons.visibility,size: height/46,
                    ),
                    onPressed: _togglePasswordStatus2,
                  ),

                  prefixIcon:Icon(Icons.lock,size: height/46,),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/46,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: JobColor.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    side: const BorderSide(
                      color: JobColor.appcolor,
                      width: 2.5,
                    ),
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(
                            () {
                          isChecked = value!;
                        },
                      );
                    },
                  ),
                  Text(
                    "Remember_me".tr,
                    style: urbanistMedium.copyWith(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: height/36,),
              InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  submitEmail(context);
                  signupUser();


                },
                child: Container(

                  height: height/15,
                  width: width/1,
                  decoration: BoxDecoration(
                    color: JobColor.appcolor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                      child: Text(
                    "Sign_up".tr,style: urbanistBold.copyWith(fontSize: 16,color: JobColor.white),)),
                ),
              ),
             SizedBox(height: height/36,),
             // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already_have_an_account'.tr,
                      style: urbanistRegular.copyWith(
                          fontSize: 14, color: JobColor.textgray)),
                  InkWell(
                    splashColor: JobColor.transparent,
                    highlightColor: JobColor.transparent,
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const JobLogin();
                        },
                      ));
                    },
                    child: Text('Sign_in'.tr,
                        style: urbanistSemiBold.copyWith(
                            fontSize: 14, color: JobColor.appcolor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
