class LoginModel {
  String? matricula;
  String? nome;

  LoginModel({
    this.matricula,
    this.nome,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    matricula = json['matricula'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    data['matricula'] = matricula;

    return data;
  }
}
