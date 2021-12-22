class Usuario {
  //int userId;
 // int id;
  int id;
  String login;
  String url;
  String html_url;
  String bio;
  String localizacao;
  String email;
  String name;
  String avatar;
  //bool favorito = false;
  Usuario({
    //this.userId,
    this.id,
    this.login,
    this.bio,
    this.localizacao,
    this.avatar,
    this.url,
    this.email,
    this.html_url,
  });

  // void setFavorito(){
  //   favorito = true;
  // }

  String getLogin(){
    return login;
  }
  factory Usuario.fromJson(Map<String, dynamic> json) {

    

    return Usuario(
      //userId: json['id'] !=null? json['id'] : 'Não informado',
      id : json['id'],
      login: json['login'] !=null? json['login'] : 'Não informado',
      bio: json['bio'] !=null ? json['bio'] : 'Não informada',
      localizacao: json['location'] !=null? json['location'] : 'Não informada',
      avatar: json['avatar_url'] !=null? json['avatar_url'] : 'Não informado',
      url: json['url'] !=null? json['url'] : 'Não informado',
      email: json['email'] !=null? json['email'] : 'Não informado',
      html_url: json['html_url'] !=null? json['html_url'] : 'Não informado',
    );
  }

  Map<String, dynamic>toJson() => {
      'id': id,
      'login': login,
      'bio': bio,
      'location': localizacao,
      'avatar_url': avatar,
      'url': url,
      'email': email,
      'html_url': html_url,


  };


}