import 'package:ceylon_explorer/Pages/register_page.dart';
import 'package:ceylon_explorer/Traveler/detail_page.dart';
import 'package:ceylon_explorer/misc/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Admin/admin_main_page.dart';
import '../Guide/guide_main_page.dart';
import '../Traveler/main_page.dart';
import 'google_page.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/login-background.png"),
                    fit: BoxFit.cover
                )
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Center(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 280,
                            ),

                            //Ceylon Explorer
                            const Text(
                              "Ceylon Explorer",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor1,
                                fontSize: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),

                            //Email
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email',
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.darkgreen2, width: 3),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.mainColor, width: 3),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.length == 0) {
                                  return "Email can not be empty";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please enter a valid email");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //Password
                            TextFormField(
                              controller: passwordController,
                              obscureText: _isObscure3,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure3
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure3 = !_isObscure3;
                                      });
                                    }),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Password',
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 08.0, top: 15.0),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(color: AppColors.darkgreen2, width: 3),
                                  borderRadius: new BorderRadius.circular(0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: AppColors.mainColor, width: 3),
                                  borderRadius: new BorderRadius.circular(0),
                                ),
                              ),
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return "Password can not be empty";
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("please enter valid password min. 6 character");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                passwordController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),

                            SizedBox(
                              height: 50,
                            ),

                            //Login
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              elevation:16.0,
                              height: 60,
                              minWidth: 280,
                              onPressed: () {
                                setState(() {
                                  visible = true;
                                });
                                signIn(
                                    emailController.text, passwordController.text);
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              color: AppColors.buttonBackground2,
                            ),
                            SizedBox(
                              height: 50,
                            ),

                            //Don´t have an account?
                            Text(
                              "Don´t have an account?",
                              style: TextStyle(
                                color: AppColors.textColor2,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //Sign up
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40.0),
                                ),
                              ),
                              //elevation: 0.0,
                              height: 50,
                              minWidth: 150,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              color: AppColors.buttonBackground2,
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),

                            //Sign in With Google
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40.0),
                                ),
                              ),
                              //elevation: 0.0,
                              height: 50,
                              minWidth: 200,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GoogleSignInScreen(),
                                  ),
                                );
                              },
                              color: AppColors.buttonBackground2,
                              child: Text(
                                "Sign in with google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //Loading Line
                            Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: visible,
                                child: Container(
                                    child: LinearProgressIndicator(
                                      color: AppColors.green,
                                    ))),


                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('roll') == "Traveler") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        }
        else if (documentSnapshot.get('roll') == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminMainPage(),
            ),
          );
        }
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TourGuide(),
            ),
          );
        }
      }
      else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
