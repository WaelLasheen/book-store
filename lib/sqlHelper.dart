import 'package:path/path.dart';
import 'book.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = 'id';
final String columnName = 'name';
final String columnAuthor = 'author';
final String columnImageUrl = 'imgUrl';
final String bookTable = 'book_table';

class bookHelper{
  late Database db;
  static final bookHelper instance = bookHelper._internal();
  factory bookHelper()=> instance;

  bookHelper._internal();

  Future open() async{
    String path = await getDatabasesPath();
    String databaseName = 'books.db';
    db = await openDatabase(
      join(path , databaseName),
      version: 1,
      onCreate: (Database db,int version) async {
        await db.execute('''
            create table $bookTable (
              $columnId integer primary key autoincrement,
              $columnName text not null,
              $columnAuthor text not null,
              $columnImageUrl text not null
            )
      ''');
      },
    );
  }

  Future<Book> insertBook(Book book) async {
    book.id = await db.insert(bookTable, book.toMap());
    return book;
  }

  Future<int> deleteBook(int id) => db.delete(bookTable ,where: '$columnId = ?' ,whereArgs: [id]);

  Future<List<Book>> getBooks() async {
    List<Map<String ,dynamic>> bookMaps = await db.query(bookTable);
    if(bookMaps.isEmpty) return [];
    List<Book> books =[];
    for(var element in bookMaps){
      books.add(Book.fromMap(element));
    }
    return books;
  }

  Future close() => db.close();


}