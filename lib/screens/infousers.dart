import 'package:flutter/material.dart';
import 'package:mobile_challenge/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoUsuario extends StatefulWidget {
  InfoUsuario({Key? key, this.usr, this.favoritar}) : super(key: key);

  final Usuario? usr;
  final Function? favoritar;

  @override
  _InfoUsuarioState createState() => _InfoUsuarioState();
}

class _InfoUsuarioState extends State<InfoUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informação do usuário'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
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
                            backgroundImage:
                                NetworkImage((widget.usr)!.avatar!),
                            radius: 30.0,
                          ),
                          title: Text(
                            "${widget.usr!.login}",
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
                                    (widget.favoritar!)(widget.usr);
                                    setState(() {
                                      (widget.usr)!.favorito =
                                          !(widget.usr)!.favorito;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                        (widget.usr)!.favorito
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.purple,
                                        size: 45.0),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsetsDirectional.only(
                                top: 10.0, start: 12.0),
                            child: Text(
                              'Localização: ${widget.usr!.localizacao}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.only(
                                top: 10.0, start: 12.0),
                            child: Text(
                              'Email: ${widget.usr!.email}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsetsDirectional.only(
                                  top: 10.0, start: 12.0),
                              child: Text('Bio: ${widget.usr!.bio}',
                                  style: TextStyle(fontSize: 16.0))),
                        ],
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () async {
                          if (!await launch((widget.usr)!.htmlurl!))
                            throw 'Não é possível abrir ${(widget.usr)!.htmlurl}';
                        },
                        child: Text(
                          '${widget.usr!.htmlurl}',
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ],
                  ),
                  elevation: 5.0,
                );
              },
              itemCount: 1,
            ))
          ],
        ),
      ),
    );
  }
}
