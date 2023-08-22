// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    id: json['id'] as int,
    union_id: json['union_id'] as int,
    category_id: json['category_id'] as int,
    name: json['name'] as String,
    designation: json['designation'] as String,
    phone: json['phone'] as String,
    created_at: json['created_at'] as String,
    updated_at: json['updated_at'] as String,
    category: json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'union_id': instance.union_id,
      'category_id': instance.category_id,
      'name': instance.name,
      'designation': instance.designation,
      'phone': instance.phone,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'category': instance.category,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as num,
    name: json['name'] as String,
    created_at: json['created_at'] as int,
    updated_at: json['updated_at'] as int,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
