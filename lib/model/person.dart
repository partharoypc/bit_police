import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class Person {
  int id;
  int union_id;
  int category_id;
  String name;
  String designation;
  String phone;
  String created_at;
  String updated_at;
  Category category;

  Person({this.id, this.union_id, this.category_id, this.name, this.designation, this.phone, this.created_at, this.updated_at, this.category});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class Category {
  num id;
  String name;
  int created_at;
  int updated_at;

  Category({this.id, this.name, this.created_at, this.updated_at});

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

