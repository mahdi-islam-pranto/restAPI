import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/screens/userPage.dart';

import 'taskPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Center(
            child: Text('Discover APIs',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: Center(
        child:
            //Show all tasks
            Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Taskpage(),
                        ));
                  },
                  child: const Text("Task API")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Userpage(),
                        ));
                  },
                  child: const Text("User API")),
            ],
          ),
        ),
      ),
    );
  }
}

class Tasks {
  int id;
  String title;
  bool completed;
  int userId;

  Tasks(
      {required this.id,
      required this.title,
      required this.completed,
      required this.userId});
}
