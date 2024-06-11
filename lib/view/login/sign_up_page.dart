import 'package:camera_ia_app/util/decoration_pattern.dart';
import 'package:camera_ia_app/util/default_button.dart';
import 'package:camera_ia_app/view/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future signIn() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(223, 228, 224, 1),
        centerTitle: true,
        title: const Text('Registrar-se'),
      ),
      backgroundColor: const Color.fromRGBO(223, 228, 224, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/iconApp.jpeg',
              height: 200,
              width: 200,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: DecorationPattern.inputDecoration,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor, insira um email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: DecorationPattern.inputDecoration,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor, insira uma senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DefaultButton(
                      onPressed: signIn,
                      text: 'Registrar-se',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Já cadastrado?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginPage(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: const Text('Faça o login aqui'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
