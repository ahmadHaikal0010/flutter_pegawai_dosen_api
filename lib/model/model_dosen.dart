// To parse this JSON data, do
//
//     final modelDosen = modelDosenFromJson(jsonString);

import 'dart:convert';

List<ModelDosen> modelDosenFromJson(String str) =>
    List<ModelDosen>.from(json.decode(str).map((x) => ModelDosen.fromJson(x)));

String modelDosenToJson(List<ModelDosen> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDosen {
  int no;
  String nip;
  String namaLengkap;
  String noTelepon;
  String email;
  String alamat;
  DateTime createdAt;
  DateTime updatedAt;

  ModelDosen({
    required this.no,
    required this.nip,
    required this.namaLengkap,
    required this.noTelepon,
    required this.email,
    required this.alamat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelDosen.fromJson(Map<String, dynamic> json) => ModelDosen(
    no: json["no"],
    nip: json["nip"],
    namaLengkap: json["nama_lengkap"],
    noTelepon: json["no_telepon"],
    email: json["email"],
    alamat: json["alamat"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "no": no,
    "nip": nip,
    "nama_lengkap": namaLengkap,
    "no_telepon": noTelepon,
    "email": email,
    "alamat": alamat,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
