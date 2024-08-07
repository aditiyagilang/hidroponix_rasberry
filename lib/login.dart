import 'package:flutter/material.dart';
import 'package:hydroponx/statusPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecuretext = true;

  void toggleObsecureText() {
    setState(() {
      obsecuretext = !obsecuretext;
    });
  }

  bool isEmailValid() {
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailPattern.hasMatch(emailController.text);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    // Reset errors
    bool emailError = false;
    bool passwordError = false;

    // Validasi email dan password tidak boleh kosong
    if (emailController.text.trim().isEmpty) {
      emailError = true;
    }
    if (passwordController.text.trim().isEmpty) {
      passwordError = true;
    }
    if (emailError || passwordError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email dan password harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Simpan UID pengguna ke dalam SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_uid', userCredential.user!.uid);
      await prefs.setString('new', "1");

      // Navigasi ke halaman utama setelah berhasil login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StatusPageScreen()),
      );
    } catch (error) {
      String errorMsg;
      if (error.toString().contains('user-not-found')) {
        errorMsg = 'Email tidak ditemukan';
      } else if (error.toString().contains('wrong-password')) {
        errorMsg = 'Password salah';
      } else {
        errorMsg = 'Terjadi kesalahan saat login';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Stack(children: [
      Opacity(
        opacity: 1,
        child: Image.asset(
          'assets/latar.png',
          fit: BoxFit.fitHeight,
          height: MediaQuery.of(context).size.height,
        ),
      ),
      Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: obsecuretext,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obsecuretext ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: toggleObsecureText,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signInWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 38, 144, 0),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Image.asset("assets/profider.png"),
        ),
      )
    ]));
  }
}
