import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydroponx/detailStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusPageScreen extends StatefulWidget {
  @override
  _StatusPageScreenState createState() => _StatusPageScreenState();
}

class _StatusPageScreenState extends State<StatusPageScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  List<String> uniqueTitles = [];
  Map<String, List<Map<String, dynamic>>> groupedData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('plan').get();
      List<Map<String, dynamic>> collectionData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Group data by title
      Map<String, List<Map<String, dynamic>>> dataMap = {};
      for (var item in collectionData) {
        String? title = item['title'] as String?;
        if (title != null) {
          if (dataMap.containsKey(title)) {
            dataMap[title]!.add(item);
          } else {
            dataMap[title] = [item];
            uniqueTitles.add(title);
          }
        }
      }

      setState(() {
        groupedData = dataMap;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/latar.png',
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Status Penyakit \n Tanaman',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: ListView.builder(
                            itemCount: uniqueTitles.length,
                            itemBuilder: (context, index) {
                              String title = uniqueTitles[index];
                              List<Map<String, dynamic>> items =
                                  groupedData[title]!;
                              var data = items.first;
                              String imageUrl =
                                  data['image'] ?? 'default_image_url';
                              String description = data['description'] ?? '';
                              String location =
                                  data['location'] ?? 'Unknown location';
                              Timestamp timestamp =
                                  data['timestamp'] ?? Timestamp.now();
                              DateTime date = timestamp.toDate();

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailStatusPageScreen(
                                        title: title,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 86,
                                        height: 86,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            color: Color(0xFFB9B2C4),
                                            fontSize: 16,
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w700,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Image.asset("assets/profider.png"),
            ),
          ),
        ],
      ),
    );
  }
}
