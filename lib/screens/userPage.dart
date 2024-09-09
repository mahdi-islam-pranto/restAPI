import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/userModel.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

// fetch user list from api
List<UserModel> userList = [];

Future<List<UserModel>> fetchUserList() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  var data = jsonDecode(response.body.toString());
  if (response.statusCode == 200) {
    for (Map i in data) {
      userList.add(UserModel.fromJson(i));
    }
    return userList;
  } else {
    throw Exception('Failed to load users');
  }
}

class _UserpageState extends State<Userpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userList.clear(); // clear the list before fetching new data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Center(
              child: Text('All Users',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    // refresh the list
                    fetchUserList();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                  future: fetchUserList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final user = snapshot.data![index];
                          return Column(
                            children: [
                              Text(
                                  "Name: ${snapshot.data![index].name.toString()}"),

                              // Text(user.company!.name.toString()),
                              Text("Company: ${user.company!.name}"),
                              const Divider(height: 10),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
