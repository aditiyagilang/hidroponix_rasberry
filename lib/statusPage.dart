import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hydroponx/detailStatus.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class StatusPageScreen extends StatefulWidget {
  @override
  _StatusPageScreenState createState() => _StatusPageScreenState();
}

class _StatusPageScreenState extends State<StatusPageScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  Map<String, dynamic>? latestData;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) => fetchData());
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('plan')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          latestData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        });
      } else {
        setState(() {
          latestData = null;
        });
      }
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
                    fontSize: 26,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : latestData != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child:
                                          Image.network(latestData!['image']),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      latestData!['description'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                          .format(latestData!['timestamp']
                                              .toDate()),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/location.png"),
                                        SizedBox(width: 10),
                                        Text(
                                          latestData!['location'],
                                          style:const TextStyle(
                                            color: Color(0xFF434E22),
                                            fontSize: 22,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w300,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const Text(
                            'No Data Available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
              
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailStatusPageScreen(
                          title: latestData!['title'] ?? 'No Title',
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          Image.asset(
                            "assets/riwayat.png",
                            width: 50,
                          ),
                          const Spacer(),
                          const Text(
                            "Lihat Riwayat",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
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
