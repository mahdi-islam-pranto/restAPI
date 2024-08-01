import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tasks> allTasksList = [];

  Future<List<Tasks>> fetchTasks() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map i in data) {
        Tasks tasks = Tasks(
          id: i['id'],
          title: i['title'],
          completed: i['completed'],
          userId: i['userId'],
        );
        allTasksList.add(tasks);
        print(tasks.title);
      }
      return allTasksList;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Center(
            child: Text('All Tasks',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: Column(
        children: [
          //Show all tasks
          Expanded(
            child: FutureBuilder(
              future: fetchTasks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: allTasksList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.data![index].id}. Title: ${snapshot.data![index].title} ",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                          Builder(
                            builder: (context) {
                              if (snapshot.data![index].completed) {
                                return Icon(Icons.check_box);
                              }

                              return Icon(Icons.check_box_outline_blank);
                            },
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
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
