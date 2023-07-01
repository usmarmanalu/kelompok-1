import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kelompok_1/Screens/dasboard.dart';
import 'package:kelompok_1/Screens/lupa_password.dart';
import 'package:kelompok_1/main.dart';

import '../constant/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final _keyValidatorLogin = GlobalKey<FormState>();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
bool _obscureText = true;

// percobaan proses authentikasi credential & validasi email dan passoword pada firebase
// https://firebase.flutter.dev/docs/auth/usage/#emailpassword-registration--sign-in
signIn() async {
  try {
    //  mengautentikasi pengguna dengan menggunakan email dan password
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    var authCredential = userCredential.user;
    print(authCredential!.uid);

    if (authCredential.uid.isNotEmpty) {
      Navigator.push(GlobalContextService.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => const Dasboard()));
    } else {
      Fluttertoast.showToast(msg: "Something is wrong");
    }
    _emailController.clear();
    _passwordController.clear();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(msg: "E-mail pengguna tidak ditemukan.");
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: "Password salah, Ulang kembali.");
    }
  } catch (e) {
    print(e);
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Image.asset('assets/images/login_images.png'),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 90),
              child: Form(
                key: _keyValidatorLogin,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'employee email',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: colorGrey),
                          contentPadding: EdgeInsets.all(0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'masukkan email anda untuk login';
                          } else {
                            _keyValidatorLogin.currentState;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'employee password',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: colorGrey,
                          ),
                          // lihat dan tutup field password
                          suffixIcon: _obscureText == true
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.visibility_off,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LupaPassword(),
                          ),
                        );
                      },
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                'Form Login Employee',
                style: TextStyle(
                  fontSize: 24,
                  color: fontColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 250),
                width: 250,
                height: 40,
                decoration: BoxDecoration(
                    color: blueColor, borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: blueColor, elevation: 0),
                  onPressed: () {
                    if (_keyValidatorLogin.currentState!.validate()) {
                      signIn();
                    }
                  },
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
