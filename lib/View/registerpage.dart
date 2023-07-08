import 'package:flutter/material.dart';
import 'package:project_bitra/View/loginScreen.dart';
import 'package:project_bitra/controller/aut_controller.dart';
import 'package:project_bitra/model/model_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  final authCtr = AuthController();
  String? userName;
  String? email;
  String? password;

  String role = 'user';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    hintText: 'Name',
                  ),
                  onChanged: (value) => userName = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if (value == null ) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                  ),
                  onChanged: (value) => password = value,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      UserModel? registeredUser =
                          await authCtr.registerWithEmailAndPassword(
                        userName!,
                        email!,
                        password!,
                        role,
                        
                      );
                      if (registeredUser != null) {
                        // Registration successful
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Registration Successful'),
                              content: const Text(
                                  'You have been successfully registered.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LoginPage();
                                    }));
                                    print(registeredUser.userName);
                                    // Navigate to the next screen or perform any desired action
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Registration failed
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Registration Failed'),
                              content: const Text(
                                  'An error occurred during registration.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
