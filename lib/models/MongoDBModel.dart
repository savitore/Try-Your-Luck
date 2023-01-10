// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
  MongoDbModel({
    required this.id,
    required this.name,
    required this.phoneno,
  });

  ObjectId id;
  String name;
  String phoneno;

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
    id: json["_id"],
    name: json["name"],
    phoneno: json["phoneno"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "phoneno": phoneno,
  };
}