import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mobile_challenge/models/user.dart';
import 'dart:async';

class UserHelpers {
  //Definindo as tabelas
  String nomeTabela = 'tbl_user';
  String colId = 'id';
  String colLogin = 'login';
  String colBio = 'bio';
  String colLocalizacao = 'location';
  String colAvatar = 'avatar_url';
  String colUrl = 'url';
  String colEmail = 'email';
  String colHtmlUrl = 'html_url';

  //Criando e conectando ao banco de dados - Padrão Singleton

  static UserHelpers? _databasehelper;
  static Database? _database;

  UserHelpers._createInstace();

  factory UserHelpers() {
    if (_databasehelper == null) {
      _databasehelper = UserHelpers._createInstace();
    }

    return _databasehelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await inicializaBanco();
    }
    return _database!;
  }

  // Criar a tabela
  void _criaBanco(Database db, int versao) async {
    await db.execute('CREATE TABLE $nomeTabela('
        '$colId INTEGER PRIMARY KEY,'
        '$colLogin Text,'
        '$colUrl Text,'
        '$colBio Text,'
        '$colLocalizacao Text,'
        '$colAvatar Text,'
        '$colEmail Text,'
        '$colHtmlUrl Text)');
  }

  Future<Database> inicializaBanco() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String caminho = directory.path + 'bdUser.bd';
    var bancodedados =
        await openDatabase(caminho, version: 1, onCreate: _criaBanco);

    return bancodedados;
  }

  //Método inserir usuário
  Future<bool> inserirUsuario(Usuario obj) async {
    Database db = await this.database;

    try {
      await db.insert(nomeTabela, obj.toJson());
      return true;
    } catch (e) {
      print("Erro ao inserir usuário");
      return false;
    }
  }

  //Método de listar Usuários
  Future<List> listarUser() async {
    Database db = await this.database;
    String sql = "SELECT * FROM $nomeTabela";
    List listaUsuarios = await db.rawQuery(sql);

    return listaUsuarios;
  }

  //Método excluir usuário
  Future<bool> excluirUsuario(int id) async {
    Database db = await this.database;
    try {
      await db.delete(nomeTabela, where: "id= ?", whereArgs: [id]);

      return true;
    } catch (e) {
      print("Erro para excluir o usuário");
      return false;
    }
  }
}
