import 'package:flutter/material.dart';

import '../share/clipper.dart';
import '../share/clipper2.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPassword = TextEditingController();
    var nameController = TextEditingController();

    Widget _buildEmail() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(3, 3),
              color: Colors.grey.shade400,
              blurRadius: 6,
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty ||
                !value.contains('@') ||
                !value.contains('.') ||
                value.length < 8) {
              return 'Por favor, digite seu e-mail';
            }
            return null;
          },
          controller: emailController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Informe seu e-mail",
            prefixIcon: Icon(Icons.email_outlined),
            contentPadding: EdgeInsets.only(top: 14),
          ),
        ),
      );
    }

    Widget _buildPassword() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(3, 3),
              color: Colors.grey.shade400,
              blurRadius: 6,
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty || value.length < 6) {
              return 'Por favor, digite sua senha';
            }
            return null;
          },
          controller: passwordController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Informe sua senha",
            prefixIcon: Icon(Icons.lock_outline),
            contentPadding: EdgeInsets.only(top: 14),
          ),
        ),
      );
    }

    Widget _buildName() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(3, 3),
              color: Colors.grey.shade400,
              blurRadius: 6,
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Por favor, digite seu nome';
            }
            return null;
          },
          controller: nameController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Informe seu nome",
            prefixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.only(top: 14),
          ),
        ),
      );
    }

    Widget _buildConfirmPassword() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(3, 3),
              color: Colors.grey.shade400,
              blurRadius: 6,
            ),
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty || value.length < 6) {
              return 'Por favor, confirme sua senha';
            }
            return null;
          },
          controller: confirmPassword,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Confirme sua senha",
            prefixIcon: Icon(Icons.lock_outline),
            contentPadding: EdgeInsets.only(top: 14),
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 300),
                  painter: RPSCustomPainter(),
                ),
                Positioned(
                  top: 16,
                  right: -5,
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 300),
                    painter: PSCustomPainter(),
                  ),
                ),
                const Positioned(
                  top: 220,
                  left: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Registre-se para continuar",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    _buildName(),
                    const SizedBox(
                      height: 25,
                    ),
                    _buildEmail(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPassword(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildConfirmPassword(),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff0f4c81),
                              Color(0xff0f4c81),
                            ],
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Cadastrar',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 80,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Já possui uma conta?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_)=>const LoginPage()));
                              },
                              child: const Text(
                                ' Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
            )
          ],
        ),
      );
  }
}