// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/textformfield.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      print("ggggggggggggggggggggggggggggggggggggggggggggggggggggg");
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context)
          .pushNamedAndRemoveUntil("homepage", (route) => false);
    } else {
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50),
                const CustomLogoAuth(),
                Container(height: 20),
                const Text("Login",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height: 10),
                const Text("Login To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: "ُEnter Your Email",
                  mycontroller: email,
                  validator: (val) {
                    if (val == "") {
                      return "Can't be Empty";
                    }
                  },
                ),
                Container(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    hinttext: "ُEnter Your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                    }),
                InkWell(
                  onTap: () async {
                    if (email.text == "") {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "Error",
                        desc: "Please Enter You Email",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "COOL",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                      return;
                    } else {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "ResetPassword is Done",
                          desc:
                              "Please Go To Your Email And Cklic Cn Link To Resrt Your Password",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "COOL",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                      } catch (e) {
                        print(e);
                        print('ERROR IS $e');
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomButtonAuth(
            title: "login",
            onPressed: () async {
              if (formState.currentState!.validate()) {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                  if (userCredential.user!.emailVerified) {
                    Navigator.of(context).pushReplacementNamed('homepage');
                  } else {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Login is Done",
                      desc:
                          "Please Go To Your Email And Cklic Cn Link To Verfy Your Email",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  }

                  print('Login successful.');
                } on FirebaseAuthException catch (e) {
                  print('An error occurred: ${e.message}');
                  if (e.code == "INVALID_LOGIN_CREDENTIALS") {
                    print(e.code);
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Invalid User",
                      desc: "invalid Email or Password",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  } else {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "No Internet",
                      desc: "chick you internet conaction",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                } catch (e) {
                  print('An unexpected error occurred: $e');
                }
              } else {
                print('invalid value');
              }
            },
          ),

          Container(height: 20),

          MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: () {
                signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset(
                    "images/4.png",
                    width: 20,
                  )
                ],
              )),
          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed("signup");
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Don't Have An Account ? ",
                ),
                TextSpan(
                    text: "Register",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
