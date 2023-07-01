import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_1/constant/color.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _validatorKey = GlobalKey<FormState>();
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _emailController = TextEditingController();

    // menginisiasi proses pengambilan data dari firebase authentication secara asyncronous
    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _resetPassword() async {
      final String email = _emailController.text;
      if (email.isNotEmpty) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Ubah Password'),
                content: const Text(
                  'Instruksi ubah password telah dikirim ke email Anda.',
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _emailController.clear();
                    },
                  ),
                ],
              );
            },
          );
        } catch (error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Maaf, Email tidak terdaftar'),
                content: Text('$error'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _emailController.clear();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: blueColor,
        title: const Text("Lupa Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _validatorKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Masukkan email yang terdaftar',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'mohon masukkan email anda ';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                child: const Center(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  if (_validatorKey.currentState!.validate()) {
                    _resetPassword();
                  } else {
                    _emailController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
