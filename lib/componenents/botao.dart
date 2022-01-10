
   import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  const Botao({Key? key, this.text = "Enviar", this.onPressed})
      : super(key: key);

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}