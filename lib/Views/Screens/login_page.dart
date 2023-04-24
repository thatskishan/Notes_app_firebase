import 'package:firebase_notes/Components/custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/firebase_auth_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  String? email1;
  String? password1;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController1 = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.orangeAccent,
      body: Form(
        key: signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: CustomPaint(
                  painter: MyPainter(),
                  child: Container(
                    height: 240,
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.5),
                          letterSpacing: 8.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              height: h * 0.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Email",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Email First";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      email = val;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Enter Email Here",
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.account_box_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Password",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Password First";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      password = val;
                    },
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      hintText: "Enter Password Here",
                      labelText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please Contact Admin"),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        "Forget Password?",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> data =
                            await FirebaseAuthHelper.firebaseAuthHelper.logIn(
                                email: emailController.text,
                                password: passwordController.text);

                        if (data['user'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Login Successfully..."),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.of(context)
                              .pushReplacementNamed('notes_screen');
                        } else if (data['msg'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(data['msg']),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Login Failed..."),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.orangeAccent,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> data = await FirebaseAuthHelper
                              .firebaseAuthHelper
                              .signInWithGoogle();

                          if (data['user'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Successfully..."),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.of(context)
                                .pushReplacementNamed('notes_screen');
                          } else if (data['msg'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(data['msg']),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Failed..."),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 1,
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset("assets/images/google.png"),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Google",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          signUpForm();
                        },
                        child: Container(
                          height: 50,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 1,
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 30,
                                width: 30,
                                child: Icon(Icons.account_box),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUpForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "Sign Up",
            style: GoogleFonts.poppins(),
          ),
        ),
        content: Form(
          key: signUpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController1,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your email first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  email1 = val;
                },
                decoration: InputDecoration(
                  hintText: "Enter Email here...",
                  hintStyle: GoogleFonts.poppins(),
                  labelText: "Email",
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController1,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your Password first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  password1 = val;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Password here...",
                  hintStyle: GoogleFonts.poppins(),
                  labelText: "Password",
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () async {
              Map<String, dynamic> data =
                  await FirebaseAuthHelper.firebaseAuthHelper.signUp(
                      email: emailController1.text,
                      password: passwordController1.text);

              if (data['user'] != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Sign Up Successfully..."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.of(context).pop;
              } else if (data['msg'] != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(data['msg']),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Login Failed..."),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              "Sign Up",
              style: GoogleFonts.poppins(),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              emailController1.clear();
              passwordController1.clear();

              setState(() {
                email1 = null;
                password1 = null;
              });

              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}
