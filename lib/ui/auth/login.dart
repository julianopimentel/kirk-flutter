import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/account_provider.dart';
import '../../service/theme/theme_provider.dart';
import '../../utils/toastr_utils.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Image logoImage = themeProvider.getLogoImage();

    // marcar o keyIsFirstLogin como false para que o usuário não veja a tela de onboarding novamente
    context.read<AccountProvider>().keyIsFirstLogin(false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 300),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height *
                      0.05, // Ajuste conforme necessário
                  right: 0,
                  left: MediaQuery.of(context).size.width * 0.5 -
                      150, // Centralize horizontalmente
                  child: logoImage,
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: 30,
                  child: const Column(
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
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
                  Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.currentTheme.primaryColor,
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
                      primary: themeProvider.currentTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize:
                          const Size(150, 50), // Definindo o tamanho mínimo
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
                    height: 150,
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
                                  builder: (_) => const RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              ' Cadastre-se',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: themeProvider.currentTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          if (value == null || value.isEmpty) {
            return 'Por favor, digite seu e-mail';
          }
          if (!value.contains('@') ||
              !value.contains('.') ||
              value.length < 8) {
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
            offset: const Offset(3, 3),
            color: Colors.grey.shade400,
            blurRadius: 6,
          ),
        ],
      ),
      child: TextFormField(
        obscureText: _obscurePassword,
        // Defina como true para ocultar o texto da senha
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
          prefixIcon: const Icon(Icons.lock_outline),
          contentPadding: const EdgeInsets.only(top: 14),
          suffixIcon: IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off),
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

  Future<void> _login() async {
    // Verifica se o email e a senha estão preenchidos
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      NotificationUtils.showWarning(context,
          'Por favor, preencha email e senha.');
      return;
    }
    AccountProvider provider = context.read<AccountProvider>();

    // Tenta realizar o login
    try {
      await provider.loginNovo(
        email: emailController.text,
        password: passwordController.text,
        context: context,
      );

    } catch (e) {
      NotificationUtils.showWarning(context,
          'Oops! Verifique sua conexão com a internet e tente novamente.');
    }
  }
}
