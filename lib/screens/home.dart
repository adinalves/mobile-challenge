import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_challenge/models/user.dart';
import 'dart:async';
import 'dart:convert';

import 'package:mobile_challenge/screens/componenents/form_user.dart';
import 'package:mobile_challenge/screens/componenents/list_user.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _loading = false;
  //var _users = new List.empty();
  var _users = new List<Usuario>();
  

  


  Future<void> searchUsuarios(String username) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    var response = await http.get(Uri.parse(
        'https://api.github.com/search/users?q=$username&page=0&per_page=10'));
    var data = jsonDecode(response.body);
    setState(() {
      _loading = false;
      _users = (data['items'] as List).map((e) => Usuario.fromJson(e)).toList();
      _users.forEach((element) {
       // print(element.login);
        

      });
        //print(_users[0].email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desafio Plurall'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            FormUser(
              onSearch: searchUsuarios,
              loading: _loading,
            ),
            Expanded(
              child: ListUser(
                users: _users,
              ),
            )
          ],
        ),
      ),
    );
  }
}
