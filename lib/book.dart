import 'package:book_store/sqlHelper.dart';

class Book{
  int? id;
  late String name;
  late String author;
  late String imgUrl;

  Book({this.id,required this.name, required this.author, required this.imgUrl});
  Book.fromMap(Map<String,dynamic> map){
    if(map[columnId] != null) id = map[columnId];
    name = map[columnName];
    author = map[columnAuthor];
    imgUrl = map[columnImageUrl];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnName] = name;
    map[columnAuthor] = author;
    map[columnImageUrl] = imgUrl;
    return map;
  }

}