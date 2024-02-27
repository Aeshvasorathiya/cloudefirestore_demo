import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class view_data extends StatefulWidget {
//  const view_data({super.key});
  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              print(data);
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['contact']),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: () {
                      users
                          .doc(document.id)
                          .delete()
                          .then((value) => print("User Deleted"))
                          .catchError((error) => print("Failed to delete user: $error"));
                    }, icon: Icon(Icons.delete)),
                    IconButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return first(document.id,data);
                      },));
                    }, icon: Icon(Icons.edit)),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
