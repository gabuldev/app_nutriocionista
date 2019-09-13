class GrupoModel {
  String nome;
  List<Alimentos> alimentos;

  GrupoModel({this.nome, this.alimentos});

  GrupoModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    if (json['alimentos'] != null) {
      alimentos = new List<Alimentos>();
      json['alimentos'].forEach((v) {
        alimentos.add(new Alimentos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    if (this.alimentos != null) {
      data['alimentos'] = this.alimentos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Alimentos {
  String nome;
  int calorias;

  Alimentos({this.nome, this.calorias});

  Alimentos.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    calorias = json['calorias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['calorias'] = this.calorias;
    return data;
  }
}
