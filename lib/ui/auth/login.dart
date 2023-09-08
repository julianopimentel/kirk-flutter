import 'package:KirkDigital/ui/ListAccountPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth_token.dart';
import '../../provider/account_provider.dart';
import '../../service/notification_service.dart';
import '../home.dart';
import '../share/clipper.dart';
import '../share/clipper2.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _onSend = true;
  bool _obscurePassword = true;

  Widget _buildEmail() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 3),
            color: Colors.grey.shade400,
            blurRadius: 6,
          ),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, digite seu e-mail';
          }
          if (!value.contains('@') || !value.contains('.') || value.length < 8) {
            return 'Por favor, digite um e-mail válido';
          }
          return null; // Retornar null indica que a validação passou
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
            offset: Offset(3, 3),
            color: Colors.grey.shade400,
            blurRadius: 6,
          ),
        ],
      ),
      child: TextFormField(
        obscureText: _obscurePassword, // Defina como true para ocultar o texto da senha
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, digite sua senha';
          }
          if (value.length < 6) {
            return 'A senha deve ter pelo menos 6 caracteres';
          }
          return null; // Retornar null indica que a validação passou
        },
        controller: passwordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Informe sua senha",
          prefixIcon: Icon(Icons.lock_outline),
          contentPadding: EdgeInsets.only(top: 14),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
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
                      "Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Faça login para continuar",
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
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                  const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _login(); // Ação a ser executada ao clicar no botão
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff0f4c81), // Cor de fundo do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(150, 50), // Definindo o tamanho mínimo
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Entrar',
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Não tem uma conta?',
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
                                      builder: (_) => RegisterPage()));
                            },
                            child: const Text(
                              ' Cadastre-se',
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
              ))
        ],
      ),
    );
  }

  Future<void> _login() async {
    // Verifica se o email e a senha estão preenchidos
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      NotificationService.showNotification('Por favor, preencha email e senha.', NotificationType.warning, context);
      return;
    }

    setState(() => _onSend = true);
    AccountProvider provider = context.read<AccountProvider>();
    AuthToken auth = await provider.login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (auth.token == null) {
      NotificationService.showNotification(auth.message ?? 'Oops! Something went wrong...', NotificationType.warning, context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ListAccountPage();
          },
        ),
        (Route<dynamic> route) => false,
      );
    }
    setState(() => _onSend = false);
  }
}