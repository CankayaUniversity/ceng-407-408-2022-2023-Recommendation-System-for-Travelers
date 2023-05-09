// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, non_constant_identifier_names

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rec4trav/models/Palette.dart';
import 'package:rec4trav/Utils/utils.dart';
import '../../Layout/mobile_layout.dart';
import '../../Layout/responsive_layout.dart';
import 'package:rec4trav/resources/auth_methods.dart';

class AuthPage extends StatefulWidget {
  AuthPage();

  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? errorMessage = '';
  bool isLogin = true;
  Uint8List? _image;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerFullname = TextEditingController();

  final TextEditingController _controllerEmail2 = TextEditingController();
  final TextEditingController _controllerPassword2 = TextEditingController();

  //@override
  // void dispose() {
  //   super.dispose();
  //   _controllerEmail.dispose();
  //   _controllerPassword.dispose();
  //   _controllerUsername.dispose();
  //   _controllerFullname.dispose();
  //   _controllerEmail2.dispose();
  //   _controllerPassword2.dispose();
  // }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  Future<void> _registerUser() async {
    try {
      String res = await AuthMethods().signUpUser(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          username: _controllerUsername.text,
          fullname: _controllerFullname.text,
          file: _image!);

      if (res == "success") {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                ),
              ),
              (route) => true);
        }
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, res);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> _login() async {
    try {
      await AuthMethods().loginUser(
          email: _controllerEmail2.text, password: _controllerPassword2.text);
      //Get.offAll(MainPage());

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
              ),
            ),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(
        () {
          errorMessage = e.message;
        },
      );
    }
  }

  // Widget _errorMessage() {
  //   return Center(
  //     child: Text(
  //       errorMessage == ' Error : ' ? '' : '$errorMessage',
  //       style: const TextStyle(color: Palette.textColor),
  //     ),
  //   );
  // }

  Widget _loginFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/rec4travlogo2.png',
              width: 300,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: const TextStyle(
                  color: Palette.black,
                ),
                cursorColor: Palette.black,
                controller: _controllerEmail2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.lightBlue2,
                  hintText: 'E-mail',
                  hintStyle: const TextStyle(color: Palette.black),
                  prefixIcon: const Icon(Icons.email),
                  prefixIconColor: Palette.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
              child: TextFormField(
                style: const TextStyle(
                  color: Palette.black,
                ),
                cursorColor: Palette.black,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _controllerPassword2,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key),
                  prefixIconColor: Palette.black,
                  filled: true,
                  fillColor: Palette.lightBlue2,
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Palette.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        //Image.file(File(_image!.path)).image,
                        backgroundColor:
                            const Color.fromARGB(255, 165, 159, 159),
                      )
                    : GestureDetector(
                        onTap: selectImage,
                        child: CircleAvatar(
                          backgroundColor: Palette.black,
                          radius: 64,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70)),
                            width: 150,
                            height: 150,
                            child: const Icon(
                              size: 45,
                              Icons.add_a_photo_outlined,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: const TextStyle(
                  color: Palette.black,
                ),
                cursorColor: Palette.lightBlue,
                controller: _controllerEmail,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.lightBlue2,
                  hintText: 'E-mail',
                  hintStyle: const TextStyle(color: Palette.black),
                  prefixIcon: const Icon(Icons.email),
                  prefixIconColor: Palette.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: const TextStyle(
                  color: Palette.black,
                ),
                cursorColor: Palette.black,
                controller: _controllerUsername,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.lightBlue2,
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: Palette.black),
                  prefixIcon: const Icon(Icons.person),
                  prefixIconColor: Palette.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: const TextStyle(
                  color: Palette.black,
                ),
                cursorColor: Palette.black,
                controller: _controllerFullname,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.lightBlue2,
                  hintText: 'Full Name',
                  hintStyle: const TextStyle(color: Palette.black),
                  prefixIcon: const Icon(Icons.text_fields),
                  prefixIconColor: Palette.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: const TextStyle(
                  color: Palette.color1,
                ),
                cursorColor: Palette.black,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _controllerPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.lightBlue2,
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Palette.black),
                  prefixIcon: const Icon(Icons.key),
                  prefixIconColor: Palette.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Palette.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _login_register_button() {
    // ignore: sized_box_for_whitespace
    return Container(
      width: 120,
      height: 60,
      child: ElevatedButton(
        // ignore: sort_child_properties_last
        child: Text(
          isLogin ? 'Login' : 'Register',
          style: const TextStyle(
              fontFamily: 'Muller', color: Palette.color5, fontSize: 18),
        ),
        onPressed: isLogin ? _login : _registerUser,
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          primary: Palette.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _login_register_text_button() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
      child: SizedBox(
        width: 280,
        height: 70,
        child: Row(
          children: [
            Text(
              isLogin
                  ? "Don't you have an account?"
                  : 'Already have an account?',
              style: const TextStyle(
                color: Palette.black,
                fontFamily: 'Muller',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              // ignore: deprecated_member_use
              style: TextButton.styleFrom(primary: Colors.grey),
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin ? "Register" : 'Login',
                style: const TextStyle(
                  color: Palette.normalBlue,
                  fontFamily: 'Muller',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgot_password_text_button() {
    return Padding(
      padding: EdgeInsets.only(left: 200),
      child: TextButton(
        // ignore: deprecated_member_use
        style: TextButton.styleFrom(primary: Colors.grey),
        onPressed: () {
          setState(() {
            print("Forgot password");
          });
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Palette.normalBlue,
            fontFamily: 'Muller',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  height: 90,
                ),
                if (isLogin) _loginFields(),
                if (!isLogin) _registerFields(),
                if (isLogin) _forgot_password_text_button(),
                _login_register_button(),
                _login_register_text_button(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
