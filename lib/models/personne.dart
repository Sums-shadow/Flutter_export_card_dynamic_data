// poemes table
class TablePersonne {
  static String tablePersonne = "personne";
  /////////////////////////////////////////////////
  static String id = "id";
  static String prenom = "prenom";
  static String nom = "nom";
  static String sexe = 'sexe';

}

//////////////////////////////////////////////////////
class Personne {
  String? _id;
  String? _prenom;
  String? _nom;
  String? _sexe;


  Personne(this._id, this._prenom, this._nom, this._sexe,);
// Getter on variables////////////////////////////////////////////////////////
  String? get id => _id;
  String get prenom => _prenom!;
  String get nom => _nom!;
  String get sexe => _sexe!;

////////////////////////////////////////////////////////////////////////////////
  Personne.fromMap(Map<String, dynamic> map)
      : _id = map["id"],
        _prenom = map["prenom"],
        _nom = map["nom"],
        _sexe = map['sexe'];
////////////////////////////////////////////////////////////////////////////////
  Map<String, dynamic> toMap() {
    // il retourne ce qui est mappé
    var map = new Map<String, dynamic>();
    map["prenom"] = _prenom;
    map["nom"] = _nom;
    map["sexe"] = _sexe;
    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }
}
