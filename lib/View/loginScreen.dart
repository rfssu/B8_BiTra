
import 'package:flutter/material.dart';
import 'package:project_bitra/View/admin/dashboardAdmin.dart';
import 'package:project_bitra/View/registerpage.dart';
import 'package:project_bitra/View/user/userPage.dart';
import 'package:project_bitra/controller/aut_controller.dart';
import 'package:project_bitra/model/model_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final authctr = AuthController();

  String? email;
  String? password;

  bool eyeToggle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                 const Padding(
                    padding: EdgeInsets.all(30),
                  ),
                const  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "BiTra",
                      style: TextStyle(
                          color: Color.fromARGB(255, 204, 244, 62),
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 407,
                    width: 370,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 245, 245),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 56, 56, 56).withOpacity(1),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(children: [
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Username/Email',
                            hintText: "Enter your username/email",
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            bool valid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!);
                            if (value.isEmpty) {
                              return "Please enter username or email";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 350,
                        height: 80,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: eyeToggle,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Password",
                              hintText: "Enter your password",
                              prefixIcon: const Icon(Icons.lock),
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    eyeToggle = !eyeToggle;
                                  });
                                },
                                child: Icon(eyeToggle
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            } else if (value.length < 6) {
                              return "Please enter your password until 6 charachter or more";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              UserModel? signUser =
                                  await authctr.signInWithEmailAndPassword(
                                      email!, password!);

                              if (signUser != null &&
                                  signUser.role == "admin") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Login Admin Successful'),
                                      content: const Text(
                                          'You have been successfully Loginned.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AdminDashboard(),
                                              ),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (signUser!.role == "user") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Login  Successful'),
                                      content: const Text(
                                          'You have been successfully Loginned.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UserHome()));                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Login failed
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Login Failed'),
                                      content: const Text(
                                          'An error occurred during Login.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()));
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
                          child: Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 19, 6, 100),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Color.fromARGB(255, 129, 191, 250)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage()));
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 34, 114)),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
