import 'package:flutter/material.dart';

import 'botao.dart';

class FormUser extends StatefulWidget {
  FormUser({Key key, this.onSearch, this.loading}) : super(key: key);

 Function onSearch;
 final bool loading;
  @override
  _FormUserState createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  final _formKey = GlobalKey<FormState>();
  var _search = "";
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
            TextFormField(
              autofocus: true,
              onChanged: (value) => setState((){
                _search = value;
              }),
              decoration: const InputDecoration(
              hintText: 'Nome do Usuário',
            ),
            validator: (String value) {
              if (value == null || value.isEmpty) {
                return 'Por favor coloue o usuário';
              }
              return null;
            },
          ),
            Botao(
              onPressed: widget.loading || _search.isEmpty ? null : () {
                if(_formKey.currentState.validate())
                {
                  widget.onSearch(_search);
                }
              },
              text: "Buscar",
            ),
            if(widget.loading) CircularProgressIndicator(),
            

      ],
    ),
    );
  }
}