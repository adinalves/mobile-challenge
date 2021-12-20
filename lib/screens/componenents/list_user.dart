import 'package:flutter/material.dart';
import 'package:mobile_challenge/models/user.dart';
import 'package:mobile_challenge/screens/infousers.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class ListUser extends StatelessWidget {
  ListUser({Key key, this.users}) : super(key: key);
  final List<Usuario> users;
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
                  backgroundImage: NetworkImage(users[index].avatar),radius: 30.0,
                  ),
                  title: Text(users[index].login),
 //                 subtitle: Text(users[index].avatar),
                  
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: ()  {
                 
                  //info(users[index].url);
                  //info(users[index].url);
                 //print(info(users[index].url));
                  
                  Navigator.push(
                  context,
      
              //MaterialPageRoute(builder: (context) => InfoUsers(url: users[index].url),
              MaterialPageRoute(builder: (context) => InfoUsers(url: users[index].url),
            ));
            
          },
                child: Text('+ Informações', textScaleFactor: 1.3,),
              ),
            ],
          ),
          elevation: 5.0,
        );
      },
      itemCount: users.length,
    );
  }
}
