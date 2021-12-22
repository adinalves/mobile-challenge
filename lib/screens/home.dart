import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_challenge/models/user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mobile_challenge/banco_de_dados/user_helpers.dart';
import 'package:mobile_challenge/screens/componenents/form_user.dart';
import 'package:mobile_challenge/screens/componenents/list_user.dart';
import 'package:mobile_challenge/screens/infousers.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  var _loading = false;
  //var _users = new List.empty();
  var _users = new List<Usuario>();
  
  List<Usuario> listadeusuarios = [];
  UserHelpers _db = UserHelpers();

   //Método de exibirTelaConfirma
  void exibirTelaConfirma(int id){
    showDialog(
      context: context 
    , builder: (context){
      return AlertDialog(
        title: Text("Excluir contato"),
        content: Text("Você tem certeza ue deseja excluir?"),
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
              print("Clicou no sim");
              removerUsuario(id);
              Navigator.pop(context);
             }, 
            child: Text("Sim"),
            
            )
        ],
      );
    });


  }

  void removerUsuario(int id) async{

    int resultado = await _db.excluirUsuario(id);

    recuperarUsuario();

  }
  
  void recuperarUsuario() async{
    List usuariosRecuperandos = await _db.listarUser();

    List<Usuario> listatemporaria = [];

    for(var item in usuariosRecuperandos){
      Usuario c = Usuario.fromJson(item);
      listatemporaria.add(c);
    }
    setState(() {
      listadeusuarios = listatemporaria;
    });
    listatemporaria = [];

  }

  @override
  void initState() {
    super.initState();
    recuperarUsuario();
  }


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
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
          
         //Text('Desafio'),
         //Center:Center(),
          Image.asset("assets/img/plurall2.png",width: 130.0,height: 130.0,),
          ]
          ),
       // leading: Image.asset("assets/img/plurall2.png",height: 10.0,width: 40.0,),
        // leading: Padding(
        //       padding: EdgeInsets.only(left: 12.0,right: 0),
        //       child: Image.asset("assets/img/plurall2.png"),
        // ),
        bottom: TabBar(
          indicatorColor: Colors.blueAccent[700],
          //labelColor: Colors.purple,
          onTap: (index) {
            print("talb");
            //recuperarUsuario();
            // setState(() {
            //   recuperarUsuario();
            // });
           },
          indicatorWeight: 5,
          tabs: [
            Tab(icon: Image.asset(
           "assets/img/image2.png",
            width: 55.0,
            height: 55.0,
           )),
            Tab(icon: Icon(Icons.favorite, color: Colors.purple,size: 30.0,),text: 'Favoritos'),
          ]
        ),
      ),
      body: TabBarView(
        children: [
         new Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            FormUser(
              onSearch: searchUsuarios,
              loading: _loading,
            ),
            Expanded(
              child: ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                  backgroundImage: NetworkImage(_users[index].avatar),radius: 30.0,
                  ),
                  title: Text(_users[index].login),
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
              MaterialPageRoute(builder: (context) => InfoUsers(url: _users[index].url),
            )).then((value) => recuperarUsuario());
            
          },
                child: Text('+ Informações', textScaleFactor: 1.3,),
              ),
            ],
          ),
          elevation: 5.0,
        );
      },
      itemCount: _users.length,
    )
            )
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
                      child: ListTile(
                        leading: CircleAvatar(
                      backgroundImage: NetworkImage(obj.avatar),
                      radius: 30.0,
                    ),
                        title: Text(
                        "Login: ${obj.login}\n\nLocalização: ${obj.localizacao}\n\nEmail: ${obj.email}\n\nBio: ${obj.bio}\n",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                       // title: Text(obj.login),
                        //subtitle: Text(obj.email),
                        //trailing: Icon(Icons.delete,color:Colors.purple),
                        //trailing: GestureDetector,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  print("clicou na lixeira ");
                                 // print(obj.id);
                                  exibirTelaConfirma(obj.id);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child:
                                      Icon(Icons.delete, color: Colors.purple,size: 40.0,),
                                )),
                        
                          ],
                        ),
                      ),
                    );
                  })
              ),
          ],
        ),
        ),
        ],
      
    )),);
    
  }
}
