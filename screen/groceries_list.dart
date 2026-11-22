import 'package:flutter/material.dart';
import 'package:groceries_app/data/categories.dart';
import 'package:groceries_app/model/grocery_item.dart';
import 'package:groceries_app/screen/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  List<GroceryItem> addType = [];
  var isLoading=true;
  String? error;

  @override
  void initState() {
    //I have use the initState method bcz to get the stored data restored or whenever i open the app the data showed up in the screen
    super.initState();
    loadType();
  }

  void loadType() async {
    final url = Uri.https(
      'flutter-app-65bee-default-rtdb.firebaseio.com',
      'Shopping-List.json',
    );
    try{
    final request = await http.get(url);
 if(request.body=='null'){
      setState(() {
         isLoading=false;
      return ;
      });
    }
    final Map<String, dynamic> listItems = json.decode(
      request.body,
    );
    final List<GroceryItem> loadedItem = [];
    for (final items in listItems.entries) {
      final category = categories.entries
          .firstWhere((cat) => cat.value.name == items.value['category'])
          .value;
      loadedItem.add(
        GroceryItem(
          id: items.key,
          name: items.value['name'],
          quantity: items.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      addType = loadedItem;
isLoading = false;
    });}
    catch (err){
setState(() {
              
      error='Unable to fetch data. PLease try again.';
    });
  }}
  void addItems() async {
   final newItem= await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));
 if(newItem==null){
  return;
 }
  setState(() {
    addType.add(newItem);
  });}
  

  void onRemove(GroceryItem item) async{
    final index=addType.indexOf(item);
 setState(() {
      addType.remove(item);
    });
    final url =  Uri.https(
      'flutter-app-65bee-default-rtdb.firebaseio.com',
      'Shopping-List/${item.id}.json',
    );
    final response = await http.delete(url);
       if(response.statusCode>400){
         setState(() {
      addType.insert(index,item);
    });
       }
  
  }
  @override
  Widget build(ctx) {
    Widget content = Center(child: Text('No Items Found!'));
    if(isLoading){
      content=Center(child: CircularProgressIndicator(),);
    }
    if (addType.isNotEmpty) {
      content = ListView.builder(
        itemCount: addType.length,
       itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) => onRemove(addType[index]),
          background: Container(color: Theme.of(ctx).colorScheme.secondary),
          key: ValueKey(addType[index].id),
          child: ListTile(
            leading: Container(
              width: 24,
              height: 24,
              color: addType[index].category.color,
            ),
            title: Text(addType[index].name),
            trailing: Text(addType[index].quantity.toString()),
          ),
        ),
      );
    }
    if(error!=null){
      content = Center(child: Text(error!));
    }
    return Scaffold(
      appBar: AppBar(
        // actionsPadding: EdgeInsets.only(left:180),
        title: Text('Your Groceries'),
        actions: [IconButton(onPressed: addItems, icon: Icon(Icons.add))],
      ),
      body: content,
    );
  }
}