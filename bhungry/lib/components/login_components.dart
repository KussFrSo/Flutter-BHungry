import 'package:bhungry/widgets/form_input.dart';
import 'package:flutter/material.dart';

class LogInComponents extends StatelessWidget {
  const LogInComponents({
    Key? key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            FormInput(
              hintText: "Correo Electrónico",
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(
              height: 24,
            ),
            FormInput(
              hintText: "Contraseña",
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
