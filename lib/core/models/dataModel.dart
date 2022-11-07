import 'dart:convert';

class DBModel {
  DBModel({
    this.id,
    this.nombre,
    this.nombreEn,
    this.picto,
    this.relacion,
    this.tipo,
  });

  int? id;
  String? nombre;
  String? nombreEn;
  String? picto;
  List<String>? relacion;
  int? tipo;
}

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  DataModel({
    this.pictos,
  });

  Pictos? pictos;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        pictos: Pictos.fromJson(json["Pictos"]),
      );

  Map<String, dynamic> toJson() => {
        "Pictos": pictos!.toJson(),
      };
}

class Pictos {
  Pictos({
    this.es,
  });

  Map<String, E>? es;

  factory Pictos.fromJson(Map<String, dynamic> json) => Pictos(
        es: Map.from(json["es"]).map((k, v) => MapEntry<String, E>(k, E.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "es": Map.from(es!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class E {
  E({
    this.id,
    this.nombre,
    this.nombreEn,
    this.picto,
    this.relacion,
    this.tipo,
  });

  int? id;
  String? nombre;
  String? nombreEn;
  String? picto;
  List<String>? relacion;
  int? tipo;

  factory E.fromJson(Map<String, dynamic> json) => E(
        id: json["id"],
        nombre: json["nombre"],
        nombreEn: json["nombre_en"],
        picto: json["picto"],
        relacion: json["relacion"] == null ? null : List<String>.from(json["relacion"].map((x) => x)),
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "nombre_en": nombreEn,
        "picto": picto,
        "relacion": relacion == null ? null : List<dynamic>.from(relacion!.map((x) => x)),
        "tipo": tipo,
      };
}


//TODO: CLEAN THIS