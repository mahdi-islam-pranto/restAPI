import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Taskpage extends StatefulWidget {
  const Taskpage({super.key});

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  @override
  void initState() {
    super.initState();
    allTasksList.clear();
  }

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
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  // refresh the list
                  fetchTasks();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
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
                          Row(
                            children: [
                              Text("User Id: ${snapshot.data![index].userId}"),
                              Builder(
                                builder: (context) {
                                  if (snapshot.data![index].completed) {
                                    return const Icon(Icons.check_box);
                                  }

                                  return const Icon(
                                      Icons.check_box_outline_blank);
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 10),
                          const SizedBox(height: 10),
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


// JSON response from https://jsonplaceholder.typicode.com/todos

// [
//   {
//     "userId": 1,
//     "id": 1,
//     "title": "delectus aut autem",
//     "completed": false
//   },
//   {
//     "userId": 1,
//     "id": 2,
//     "title": "quis ut nam facilis et officia qui",
//     "completed": false
//   },
//   {
//     "userId": 1,
//     "id": 3,
//     "title": "fugiat veniam minus",
//     "completed": false
//   },
//   {
//     "userId": 1,
//     "id": 4,
//     "title": "et porro tempora",
//     "completed": true
//   }
// ]
