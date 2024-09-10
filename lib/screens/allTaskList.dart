import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/taskListModel.dart';
import 'package:http/http.dart' as http;

class AllTaskList extends StatefulWidget {
  const AllTaskList({super.key});

  @override
  State<AllTaskList> createState() => _AllTaskListState();
}

// fetch task from API
Future<TaskListModel> getTaskList() async {
  final response = await http.post(
    Uri.parse("https://webhook.site/2e203c32-3009-4d23-a023-2e8793f33a0c"),
  );
  // print(response.body.toString());
  var data = jsonDecode(response.body.toString());

  if (response.statusCode == 200) {
    print("########Response task data: $data");
    return TaskListModel.fromJson(data);
  } else {
    // Handle error
    return TaskListModel.fromJson(data);

    // You can also show an error message if needed
  }
}

class _AllTaskListState extends State<AllTaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        title: Container(
          height: 35,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('All Tasks'),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black87,
            ),
          ),
        ],
      ),

      // body
      body: Container(
        color: Colors.white30,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getTaskList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 5, left: 20, right: 20),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.data![index].companyName!
                                            .companyName
                                            .toString(),
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      Text(
                                          "Status:  ${snapshot.data!.data![index].taskStatus!.name}"),
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.manage_accounts_rounded),
                                          const SizedBox(width: 5),
                                          Text(
                                            snapshot.data!.data![index]
                                                .assignName!.name
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(snapshot
                                          .data!.data![index].taskName!.name
                                          .toString()),
                                      Card(
                                          borderOnForeground: true,
                                          shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          color: Colors.white60,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(snapshot
                                                .data!.data![index].endTime
                                                .toString()),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              //

                              const Divider(),
                            ],
                          ),
                        );
                        // return ListTile(
                        //   title: Text(snapshot
                        //       .data!.data![index].companyName!.companyName
                        //       .toString()),
                        //   subtitle:
                        //       Text(snapshot.data!.data![index].description!),
                        // );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
