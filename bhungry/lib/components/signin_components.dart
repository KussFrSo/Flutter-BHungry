import 'package:bhungry/widgets/form_input.dart';
import 'package:flutter/material.dart';

class SigInComponents extends StatelessWidget {
  const SigInComponents({
    Key? key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
  })  : _emailController = emailController,
        _passwordController = passwordController,
        _nameController = nameController,
        super(key: key);
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(children: [
          const SizedBox(
            height: 18,
          ),
          FormInput(
            hintText: "Nombre Completo",
            textInputType: TextInputType.emailAddress,
            textEditingController: _nameController,
          ),
          const SizedBox(
            height: 18,
          ),
          FormInput(
            hintText: "Correo Electrónico",
            textInputType: TextInputType.emailAddress,
            textEditingController: _emailController,
          ),
          const SizedBox(
            height: 18,
          ),
          FormInput(
            hintText: "Contraseña",
            textInputType: TextInputType.text,
            textEditingController: _passwordController,
            isPass: true,
          ),
          const SizedBox(height: 21),
        ]),
      ),
    );
  }
}
