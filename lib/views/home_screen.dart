import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:machers_task/services/api_functions.dart';

import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamController<Map<String, dynamic>> streamController =
      StreamController<Map<String, dynamic>>();

  getAllNews() async {
    try {
      var response = await ApiFunctions().getAllNews(context);
      if (response != null //&& response['status'] == "ok"
          ) {
        streamController.sink.add(response);
        log("PRINTING DATA ${response.toString()}");
      } else {
        log("PRINTING DATA ${response.toString()}");
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        getAllNews();
      });
    });
  }

  @override
  void dispose() {
    streamController.close();

    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      getAllNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary_color,
        centerTitle: true,
        title: const Text(
          "News App",
          style: TextStyle(
            color: white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: primary_color,
        child: StreamBuilder(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!['data'].length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!['data'][index];
                    var currentIndex = index + 1;
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primary_color.withOpacity(0.3),
                            child: Text(
                              currentIndex.toString(),
                              style: const TextStyle(
                                color: black,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          title: Text(
                            data['title'].toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['description'].toString(),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: grey.withOpacity(0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                data['url'].toString(),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  color: blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            data['language'].toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              color: primary_color,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Divider(
                            color: grey,
                            thickness: 0.4,
                          ),
                        )
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
