import 'package:flutter/material.dart';
import 'package:mobile_challenge/models/user.dart';
import 'package:mobile_challenge/screens/infousers.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:mobile_challenge/banco_de_dados/user_helpers.dart';




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


// class ListUserFavoritados extends StatelessWidget {
//   ListUserFavoritados({Key key, this.users}) : super(key: key);


//   UserHelpers _db = UserHelpers();

// void removerUsuario(int id) async{
//   int resultado = await _db.excluirUsuario(id);
// }

//   final List<Usuario> users;
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return Card(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                   backgroundImage: NetworkImage(users[index].avatar),radius: 30.0,
//                   ),
//                //   title: Text("Login: $users[index].login"),
//                  title: Text(
//                        "Login: ${users[index].login}\n\nLocalização: ${users[index].localizacao}\n\nEmail: ${users[index].email}\n\nBio: ${users[index].bio}\n",
//                        style: TextStyle(fontWeight: FontWeight.bold)),
//  //                 subtitle: Text(users[index].avatar),
//                   trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             GestureDetector(
//                                 onTap: () {
//                                   removerUsuario(users[index].id);
//                                   print("clicou na lixeira ");
//                                  // print(obj.id);
//                                   //exibirTelaConfirma(obj.id);
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.only(right: 16),
//                                   child:
//                                       Icon(Icons.delete, color: Colors.purple, size: 40.0),
//                                 )),
                            
//                           ],
//                         )
//                 ),
//               ),
              
//             ],
//           ),
//           elevation: 5.0,
//         );
//       },
//       itemCount: users.length,
//     );
//   }
// }
