import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';

class CategoryModel extends MyCategory {
  CategoryModel({required int id, required String name})
    : super(id: id, name: name);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
