import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudefirestore_demo/view_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: first(),
    debugShowCheckedModeBanner: false,
  ));
}
class first extends StatefulWidget {
  //const first({super.key});
  String ?id;

 // first([this.id,this.data]);
 Map<String,dynamic>?data;
  first([this.id,this.data]);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.id!=null)
      {
        t1.text=widget.data!['name'];
        t2.text=widget.data!['contact'];
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: t1,
          ),
          TextField(
            controller: t2,
          ),
          ElevatedButton(onPressed: () {
            String name=t1.text;
            String contact=t2.text;
            if(widget.id!=null)
              {
                users
                    .doc(widget.id)
                    .update({'name': name ,'contact':contact})
                    .then((value) => print("User Updated"))
                    .catchError((error) => print("Failed to update user: $error"));
              }
            else
              {
                users
                    .add({
                  'name': name, // John Doe
                  'contact': contact, // Stokes and Sons

                })
                    .then((value) => print("User Added"))
                    .catchError((error) => print("Failed to add user: $error"));
              }
    },
          child: Text("Submit")),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return view_data();
            },));
            
          }, child: Text("view"))
        ],
      ),
    );
  }
}
