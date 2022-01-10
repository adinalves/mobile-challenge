class Usuario {
  int? id;
  String? login;
  String? url;
  String? htmlurl;
  String? bio;
  String? localizacao;
  String? email;
  String? name;
  String? avatar;
  bool favorito;

  Usuario({
    this.id,
    this.login,
    this.bio,
    this.localizacao,
    this.avatar,
    this.url,
    this.email,
    this.htmlurl,
    this.favorito = false,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      login: json['login'] != null ? json['login'] : 'Não informado',
      bio: json['bio'] != null ? json['bio'] : 'Não informada',
      localizacao:
          json['location'] != null ? json['location'] : 'Não informada',
      avatar: json['avatar_url'] != null ? json['avatar_url'] : 'Não informado',
      url: json['url'] != null ? json['url'] : 'Não informado',
      email: json['email'] != null ? json['email'] : 'Não informado',
      htmlurl: json['html_url'] != null ? json['html_url'] : 'Não informado',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'bio': bio,
        'location': localizacao,
        'avatar_url': avatar,
        'url': url,
        'email': email,
        'html_url': htmlurl,
      };
}
