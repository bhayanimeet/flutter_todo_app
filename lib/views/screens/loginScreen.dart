import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../controllers/firebase_login_controller.dart';
import 'homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  String? email;
  String? password;

  bool isVisible = true;

  String status = "Create account";
  String logIn = "Sign Up";
  String account = "Already account?";
  String signIn = " Sign in";

  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade800,
                  Colors.blue.shade700,
                  Colors.blue.shade600,
                  Colors.blue.shade500,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 75),
                Image.asset(
                  'assets/images/logo.png',
                  scale: 2.8,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 15),
                  child: Text(
                    status,
                    style: GoogleFonts.arya(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    controller: emailController,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    enableSuggestions: true,
                    showCursor: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.play(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    onSaved: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter email first...";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      focusColor: Colors.white,
                      labelText: "Email",
                      labelStyle:
                      GoogleFonts.arya(fontSize: 25, color: Colors.white),
                      hintText: "Enter Email",
                      prefixIcon: const Icon(Icons.email_outlined,
                          color: Colors.white, size: 28),
                      errorStyle: GoogleFonts.play(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      hintStyle: GoogleFonts.play(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    enableSuggestions: true,
                    showCursor: false,
                    obscureText: isVisible,
                    // textInputAction: TextInputAction.next,
                    style: GoogleFonts.play(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    onSaved: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Password first...";
                      }
                      return null;
                    },
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        child: Icon(
                          (isVisible == true)
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                      focusColor: Colors.white,
                      labelText: "Password",
                      labelStyle:
                      GoogleFonts.arya(fontSize: 25, color: Colors.white),
                      hintText: "Enter Password",
                      prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.white),
                      errorStyle: GoogleFonts.play(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      hintStyle: GoogleFonts.play(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () async {
                        await FirebaseHelper.firebaseAuth
                            .sendPasswordResetEmail(email: email!);
                      },
                      child: Text(
                        "Forgot password ?",
                        style: GoogleFonts.arya(
                          fontSize: 20,
                          color: Colors.teal.shade200,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      if (isSignUp == true) {
                        Map<String, dynamic> res = await FirebaseHelper
                            .firebaseHelper
                            .signUp(email: email!, password: password!);

                        if (res['user'] != null) {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          await prefs.setBool('isLogged', true);
                          Get.off(
                                () => const HomePage(),
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            transition: Transition.fadeIn,
                          );
                        } else if (res['error'] != null) {
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Error',
                              backgroundColor: Colors.indigo.shade100,
                              snackPosition: SnackPosition.BOTTOM,
                              borderRadius: 20,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(15),
                              message: res['error'],
                              snackStyle: SnackStyle.FLOATING,
                            ),
                          );
                        } else {
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Error',
                              backgroundColor: Colors.indigo.shade100,
                              snackPosition: SnackPosition.BOTTOM,
                              borderRadius: 20,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(15),
                              message: 'Please check internet connection...',
                              snackStyle: SnackStyle.FLOATING,
                            ),
                          );
                        }
                      } else if (isSignUp == false) {
                        Map<String, dynamic> res = await FirebaseHelper
                            .firebaseHelper
                            .signIn(email: email!, password: password!);

                        if (res['user'] != null) {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          await prefs.setBool('isLogged', true);
                          Get.off(
                                () => const HomePage(),
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            transition: Transition.fadeIn,
                          );
                        } else if (res['error'] != null) {
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Error',
                              backgroundColor: Colors.indigo.shade100,
                              snackPosition: SnackPosition.BOTTOM,
                              borderRadius: 20,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(15),
                              message: res['error'],
                              snackStyle: SnackStyle.FLOATING,
                            ),
                          );
                        } else {
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Error',
                              backgroundColor: Colors.indigo.shade100,
                              snackPosition: SnackPosition.BOTTOM,
                              borderRadius: 20,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(15),
                              message: 'Please check internet connection...',
                              snackStyle: SnackStyle.FLOATING,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        color: Colors.blue,
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                        shadowLightColor: Colors.transparent,
                        surfaceIntensity: 0.5,
                        lightSource: LightSource.bottomLeft,
                        oppositeShadowLightSource: true,
                      ),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                          alignment: const Alignment(0, -0.2),
                          child: Text(
                            logIn,
                            style: GoogleFonts.arya(
                                color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 140,
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "OR",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 140,
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> res = await FirebaseHelper
                          .firebaseHelper
                          .signInWithGoogle();

                      if (res['user'] != null) {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        await prefs.setBool('isLogged', true);
                        Get.off(
                              () => const HomePage(),
                          curve: Curves.easeInOut,
                          transition: Transition.fadeIn,
                          duration: const Duration(seconds: 1),
                        );
                      } else if (res['error'] != null) {
                        Get.showSnackbar(
                          GetSnackBar(
                            title: 'Error',
                            backgroundColor: Colors.indigo.shade100,
                            snackPosition: SnackPosition.BOTTOM,
                            borderRadius: 20,
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.all(15),
                            message: res['error'],
                            snackStyle: SnackStyle.FLOATING,
                          ),
                        );
                      } else {
                        Get.showSnackbar(
                          GetSnackBar(
                            title: 'Error',
                            backgroundColor: Colors.indigo.shade100,
                            snackPosition: SnackPosition.BOTTOM,
                            borderRadius: 20,
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.all(15),
                            message: 'Please check network connection...',
                            snackStyle: SnackStyle.FLOATING,
                          ),
                        );
                      }
                    },
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        color: Colors.blue,
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                        shadowLightColor: Colors.transparent,
                        surfaceIntensity: 0.5,
                        lightSource: LightSource.bottomLeft,
                        oppositeShadowLightSource: true,
                      ),
                      child: Container(
                        height: 47,
                        width: 120,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google.png',
                                height: 25, filterQuality: FilterQuality.high),
                            const SizedBox(width: 10),
                            const Text(
                              "Google",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      account,
                      style: GoogleFonts.arya(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSignUp == false) {
                            isSignUp = true;
                            status = "Create account";
                            logIn = "Sign Up";
                            account = "Already account?";
                            signIn = " Sign In";
                          } else if (isSignUp == true) {
                            isSignUp = false;
                            status = "Welcome back!";
                            logIn = "Sign In";
                            account = "Don't have an account?";
                            signIn = " Create new";
                          }
                        });
                      },
                      child: Text(
                        signIn,
                        style: GoogleFonts.arya(
                          fontSize: 18,
                          color: Colors.teal.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
