import 'package:book_store/book.dart';
import 'package:book_store/sqlHelper.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bookHelper.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<Book> books = [];
  List<String> images = ['images/p.jpg','images/h.jpg','images/s.jpg'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Available Books',
          style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8,12,8,10),
        child: FutureBuilder<List<Book>>(
          future: bookHelper.instance.getBooks(),
          
          builder:(context ,snapshot){
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if(snapshot.hasData){
              books = snapshot.data!;
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (BuildContext context, int index) { 
                  Book book = books[index];
                  return ListTile(
                    title: Text(book.name), 
                    subtitle: Text(book.author), 
                    trailing: IconButton(
                      onPressed: (){
                        setState(() {
                          bookHelper.instance.deleteBook(book.id!);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book Delete Successfully')));
                      },
                      icon: const Icon(Icons.delete_forever , color: Colors.red,size: 28,)
                    ),
                    leading: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3),
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(image: AssetImage(images.contains(book.imgUrl)? book.imgUrl : images[0]), fit: BoxFit.cover)
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async{
          TextEditingController nameController = TextEditingController();
          TextEditingController authorController = TextEditingController();
          TextEditingController imgUrlController = TextEditingController();

          await showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context){
              return SizedBox(
                height: 300 + MediaQuery.of(context).viewInsets.bottom,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(hintText: 'Book Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      child: TextField(
                        controller: authorController,
                        decoration: const InputDecoration(hintText: 'Auther Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      child: TextField(
                        controller: imgUrlController,
                        decoration: const InputDecoration(hintText: 'Image URL'),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: (){
                          bookHelper.instance.insertBook(
                            Book(name: nameController.text, author: authorController.text, imgUrl: imgUrlController.text)
                          );
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Book Added Successfully')
                            )
                          );
                          Navigator.of(context).pop();
                          setState(() {});
                        }, 
                        child: const Text('SAVE')
                      ),
                    ),
                  ]
                ),
              );
            }
          );
        },
      
      ),
    );
  }
}