import 'package:flutter/material.dart';

import 'botao.dart';

class FormUser extends StatefulWidget {
  FormUser(
      {Key? key,
      this.repo,
      this.changeRepo,
      required this.onSearch,
      this.loading})
      : super(key: key);

  final String? repo;
  final void Function(String value)? changeRepo;
  final Function onSearch;
  final bool? loading;
  @override
  _FormUserState createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            onChanged: widget.changeRepo,
            decoration: const InputDecoration(
              hintText: 'Nome do Usuário',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor insira um usuário';
              }
              return null;
            },
          ),
          Botao(
            onPressed: widget.loading! || widget.repo!.isEmpty
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSearch();
                    }
                  },
            text: "Buscar",
          ),
          //if(widget.loading) CircularProgressIndicator(),
        ],
      ),
    );
  }
}
