import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_challenge/banco_de_dados/user_helpers.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mobile_challenge/models/user.dart';

import 'package:mobile_challenge/screens/componenents/botao.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_challenge/banco_de_dados/user_helpers.dart';

class InfoUsers extends StatefulWidget {
  InfoUsers({Key key, this.url}) : super(key: key);
  String url;

  @override
  _InfoUsersState createState() => _InfoUsersState();
}

class _InfoUsersState extends State<InfoUsers> {
  Usuario _user;

  Future<void> info(url) async {
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    setState(() {
      _user = Usuario.fromJson(data);
      count = 1;
    });
    // _user = Usuario.fromJson(data);
    // count++;

    //print(data);
    print(data);
  }

  var count = 0;

  @override
  // Widget build(BuildContext context){
  //   info(widget.url);

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Segunda Rota (tela)"),
  //     ),
  //     body: Center(
  //       child: RaisedButton(
  //         onPressed: () {

  //           Navigator.pop(context);

  //         },
  //         child: Text(widget.url),
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    if (count == 0) {
      // info("https://api.github.com/users/adinalves");
      info(widget.url);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Desafio Plurall'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            // FormeUser(
            //   onInfo: info,

            // ),
            Expanded(
              child: ListarUser(
                user: _user,
                count: count,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListarUser extends StatelessWidget {
  void SalvarUsuario(context, Usuario user) async {
    bool resultado = await _db.inserirUsuario(user);

    if (resultado) {
      print("Salvo com sucesso" + resultado.toString());
      showDialog(context: context, builder: (_) => AlertDialog(title: Text("Usuário favoritado com sucesso!"),));
    } else {
      print("Erro ao Salvar!");
      showDialog(context: context, builder: (_) => AlertDialog(title: Text("Usuário já está favoritado."),));
    }
    
    
  }

  void exibirTelaFavorito(context, Usuario usuario) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Favoritar Usuário"),
            content: Text("Você deseja favoritar este usuário?"),
            backgroundColor: Colors.white,
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print("Clicou no cancelar");
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  SalvarUsuario(context, usuario);
                  print("Clicou no sim");
                  Navigator.pop(context);
                },
                child: Text("Sim"),
              )
            ],
          );
        });
  }

  UserHelpers _db = UserHelpers();

  ListarUser({Key key, this.user, this.count}) : super(key: key);
  final Usuario user;
  final count;
  // Usuario user;
  // Future<void> info(String url) async {
  //   var response = await http.get(Uri.parse(url));
  //   var data = jsonDecode(response.body);

  //   user.login = data['login'];
  //   user.avatar = data['avatar_url'];
  //   user.localizacao = data['location'];
  //   user.bio = data['bio'];
  //   user.email = data['email'];
  //   user.userId = data['id'];

  // }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar),
                      radius: 30.0,
                    ),
                    title: Text(
                        "Login: ${user.login}\n\nLocalização: ${user.localizacao}\n\nEmail: ${user.email}\n\nBio: ${user.bio}\n",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    //subtitle: Text("${user.url}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () async {
                              exibirTelaFavorito(context, user);
                              // bool resultado = await _db.inserirUsuario(user);

                              // if (resultado) {
                              //         print("Salvo com sucesso" + resultado.toString());
                              // } else {
                              //         print("Erro ao Salvar!");
                              //   }

                              print("clicou no coracao ");
                              // print(obj.id);
                              // exibirTelaConfirma(obj.id);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.favorite,
                                  color: Colors.purple, size: 45.0),
                            )),
                      ],
                    ),
                  ),
                ),
                // TextButton(
                //   style: ButtonStyle(
                //     foregroundColor:
                //         MaterialStateProperty.all<Color>(Colors.red),
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);

                //     //info(users[index].url);
                //     //info(users[index].url);
                //     //print(info(users[index].url));
                //   },
                //   child: Text(
                //     'FAVORITAR',
                //     textScaleFactor: 1.3,
                //   ),
                // ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () async {
                    //Navigator.pop(context);
                    if (!await launch(user.html_url))
                      throw 'Não é possível abrir ${user.html_url}';
                    //info(users[index].url);
                    //info(users[index].url);
                    //print(info(users[index].url));
                  },
                  child: Text(
                    '${user.html_url}',
                    textScaleFactor: 1.3,
                  ),
                ),
              ],
            ),
            elevation: 5.0,
          );
        },
        itemCount: count);
  }
}
