import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hydroponx/statusPage.dart';


class DetailStatusPageScreen extends StatefulWidget {
  final String title;

  DetailStatusPageScreen({required this.title});

  @override
  _DetailStatusPageScreenState createState() => _DetailStatusPageScreenState();
}

class _DetailStatusPageScreenState extends State<DetailStatusPageScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  List<Map<String, dynamic>> collectionData = [];

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
      QuerySnapshot querySnapshot = await _firestore
         .collection('plan')
          .orderBy('timestamp', descending: true) 
          .get();
      setState(() {
        collectionData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
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
              'assets/latar2.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StatusPageScreen()),
                        );
                      },
                      child: Image.asset("assets/back.png"),
                    ),
                    const Spacer(),
                    Text(
                      "Riwayat",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: ListView.builder(
                            itemCount: collectionData.length,
                            itemBuilder: (context, index) {
                              var data = collectionData[index];
                              String imageUrl =
                                  data['image'] ?? 'default_image_url';
                              String status = data['title'] ?? 'Unknown status';
                              String description = data['description'] ?? '';
                              String location =
                                  data['location'] ?? 'Unknown location';
                              Timestamp timestamp =
                                  data['timestamp'] ?? Timestamp.now();
                              DateTime date = timestamp.toDate();

                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DetailPopup(
                                        date: date.toString(),
                                        location: location,
                                        image: imageUrl,
                                        title: status,
                                        description: description,
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 105,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                date
                                                    .toString()
                                                    .substring(0, 16),
                                                style: TextStyle(
                                                  color: Color(0xFF434E22),
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      "assets/location.png"),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    location,
                                                    style: TextStyle(
                                                      color: Color(0xFF434E22),
                                                      fontSize: 10,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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

class DetailPopup extends StatelessWidget {
  final String date;
  final String location;
  final String image;
  final String title;
  final String description;

  DetailPopup(
      {required this.date,
      required this.location,
      required this.title,
      required this.description,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF434E22),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            date.substring(0, 16),
            style: TextStyle(
              color: Color(0xFF434E22),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              Image.asset("assets/location.png"),
              SizedBox(width: 10),
              Text(
                location,
                style: TextStyle(
                  color: Color(0xFF434E22),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                ),
              ),
            ],
          ),
          Text(
            description,
            style: TextStyle(
              color: Color(0xFF434E22),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
