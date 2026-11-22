import 'package:groceries_app/data/blueprint.dart';
// import 'package:groceries_app/model/category.dart';

class GroceryItem{
  const GroceryItem({required this.id,required this.name,required this.quantity,required this.category,});
  final String id;
  final String name;
  final int quantity;
  final Category category;
}