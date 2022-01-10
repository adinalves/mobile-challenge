import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_challenge/models/user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mobile_challenge/banco_de_dados/user_helpers.dart';
import 'package:mobile_challenge/componenents/form_user.dart';
import 'package:mobile_challenge/screens/infousers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  bool _loading = false;
  List<Usuario> _users = [];

  bool _finishScroll = false;
  int _currentPage = 1;
  String _username = '';
  bool flagErro = false;

  List<Usuario> listadeusuarios = [];
  UserHelpers _db = UserHelpers();

  void salvarUsuario(Usuario user) async {
    user = await info(user);
    await _db.inserirUsuario(user);
    listadeusuarios.add(user);
    setState(() {
      user.favorito = true;
    });
  }

  void exibirTelaErro() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erro ao conectar com o servidor"),
            content: Text(
                "Não foi possível conectar com a API do GitHub, verifique sua conexão com a internet ou se o limite requisições excedeu."),
            backgroundColor: Colors.white,
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  void exibirTelaConfirma(Usuario u) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Desfavoritar contato"),
            content:
                Text("Você tem certeza que deseja desfavoritar este usuário?"),
            backgroundColor: Colors.white,
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  removerUsuario(u);
                  Navigator.pop(context);
                },
                child: Text("Sim"),
              )
            ],
          );
        });
  }

  void removerUsuario(Usuario u) async {
    await _db.excluirUsuario(u.id!);
    setState(() {
      u.favorito = false;
    });
    listadeusuarios.removeWhere((item) => item.id == u.id);
  }

  void recuperarUsuario() async {
    List usuariosRecuperandos = await _db.listarUser();

    setState(() {
      listadeusuarios =
          (usuariosRecuperandos).map((e) => Usuario.fromJson(e)).toList();
    });
  }

  List<Usuario> userfavorito(List<Usuario> usr) {
    //print(_users.map((e) => e.id).contains(listadeusuarios[0].id));

    for (int i = 0; i < usr.length; i++) {
      if (listadeusuarios.map((e) => e.id).contains(usr[i].id)) {
        usr[i].favorito = true;
      }
    }

    return usr;

    // for (int i = 0; i < _users.length; i++) {
    //   for (int j = 0; j < listadeusuarios.length; j++) {
    //     if (_users[i].id == listadeusuarios[j].id) {
    //       _users[i].favorito = true;
    //     }
    //   }
    // }
  }

  Future<Usuario> info(Usuario usr) async {
    try {
      var response = await http.get(Uri.parse(usr.url.toString()), headers: {
        HttpHeaders.authorizationHeader:
            dotenv.get('TOKEN', fallback: 'Token não encontrado')
      });
      // if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      usr.localizacao = data['location'];
      usr.email = data['email'];
      usr.htmlurl = data['html_url'];
      usr.bio = data['bio'];
      return usr;
    } catch (e) {
      print('Falha ao buscar as informações do usuário' + usr.login.toString());
      throw Exception(
          'Falha ao buscar as informações do usuário' + usr.login.toString());
    }
  }

  Future<void> searchUsuarios({int page = 1}) async {
    if (_loading) return;

    setState(() {
      if (page == 1 && _users.isNotEmpty) {
        flagErro = false;

        _users.clear();
        _finishScroll = false;
      }
    });

    setState(() {
      _loading = true;
    });
    try {
      var response = await http.get(
          Uri.parse(
              'https://api.github.com/search/users?q=$_username&page=$page&per_page=10'),
          headers: {
            HttpHeaders.authorizationHeader:
                dotenv.get('TOKEN', fallback: 'Token não encontrado')
          });
      print(response.statusCode);
      //if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var items = (data['items'] as List);
      setState(() {
        _loading = false;
        _currentPage = page;

        if (items.isEmpty) {
          _finishScroll = true;
          return;
        }

        var aux =
            (data['items'] as List).map((e) => Usuario.fromJson(e)).toList();
        _users += userfavorito(aux);
      });
    } catch (e) {
      print('entrouu');
      setState(() {
        flagErro = true;
        _loading = false;
      });
      exibirTelaErro();
      print('Erro ao buscar as informações dos usuários');
    }
  }

  void favoritar(Usuario user) {
    if (user.favorito) {
      removerUsuario(user);
    } else {
      salvarUsuario(user);
    }
  }

  @override
  void initState() {
    super.initState();
    recuperarUsuario();

    _scrollController.addListener(() {
      double pixels = _scrollController.position.pixels;
      double scrollSize = _scrollController.position
          .maxScrollExtent; // Se tiver no final da lista pode-se buscar novos usuarios

      if (pixels == scrollSize && !_finishScroll) {
        searchUsuarios(page: _currentPage + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/img/plurall2.png",
                    width: 130.0,
                    height: 130.0,
                  ),
                ]),
            bottom: TabBar(
                indicatorColor: Colors.blueAccent[700],
                onTap: (index) {},
                indicatorWeight: 5,
                tabs: [
                  Tab(
                      icon: Image.asset(
                    "assets/img/image2.png",
                    width: 55.0,
                    height: 55.0,
                  )),
                  Tab(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.purple,
                        size: 30.0,
                      ),
                      text: 'Favoritos'),
                ]),
          ),
          body: TabBarView(
            children: [
              new Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    FormUser(
                      repo: _username,
                      changeRepo: (value) {
                        setState(() {
                          _username = value;
                        });
                      },
                      onSearch: searchUsuarios,
                      loading: _loading,
                    ),
                    if (_users.isNotEmpty)
                      Expanded(
                          child: ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              if (!flagErro) {
                                Usuario aux = await info(_users[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoUsuario(
                                        usr: aux,
                                        favoritar: favoritar,
                                      ),
                                    ));
                              } else {
                                exibirTelaErro();
                              }
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(_users[index].avatar!),
                                        radius: 30.0,
                                      ),
                                      title: Text(_users[index].login!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                              fontSize: 20.0)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () async {
                                                if (!flagErro) {
                                                  favoritar(_users[index]);
                                                  // favoritar(_usersInfo[index]);
                                                } else
                                                  exibirTelaErro();
                                              },
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 16),
                                                child: Icon(
                                                  _users[index].favorito
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.purple,
                                                  size: 40.0,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                    ),
                                    onPressed: () async {
                                      //print(_users[index].bio);
                                      if (!flagErro) {
                                        Usuario aux = await info(_users[index]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InfoUsuario(
                                                favoritar: favoritar,
                                                usr: aux,
                                              ),
                                            ));
                                      } else {
                                        exibirTelaErro();
                                      }
                                    },
                                    child: Text(
                                      '+ Informações',
                                      textScaleFactor: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                              elevation: 3.0,
                            ),
                          );
                        },
                        itemCount: _users.length,
                      )),
                    if (_loading)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                            itemCount: listadeusuarios.length,
                            itemBuilder: (context, index) {
                              final Usuario obj = listadeusuarios[index];
                              return Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(obj.avatar!),
                                          radius: 30.0,
                                        ),
                                        title: Text(
                                          "${obj.login}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                              fontSize: 20.0),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            GestureDetector(
                                                onTap: () {
                                                  exibirTelaConfirma(obj);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 16),
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.purple,
                                                    size: 40.0,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  top: 10.0, start: 12.0),
                                          child: Text(
                                            'Localização: ${obj.localizacao}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  top: 10.0, start: 12.0),
                                          child: Text(
                                            'Email: ${obj.email}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                        Container(
                                            margin: const EdgeInsetsDirectional
                                                    .only(
                                                top: 10.0,
                                                start: 12.0,
                                                bottom: 12.0),
                                            child: Text('Bio: ${obj.bio}',
                                                style:
                                                    TextStyle(fontSize: 16.0))),
                                      ],
                                    ),
                                  ],
                                ),
                                elevation: 3.0,
                              );
                            })),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
