import 'package:flutter/material.dart';
// import 'package:student_portal/components/homePageButton.dart';
import 'package:student_portal/components/web_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExternalLink {
  final String title;
  final String link;

  ExternalLink({required this.title, required this.link});
}

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  List<ExternalLink> thirdPartyLinks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void navigateToWebView(String title, String link) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(title: title, link: link),
      ),
    );
  }

  Future<void> _fetchAllData() async {
    final thirdPartySnapshot =
        await FirebaseFirestore.instance.collection("third_party").get();
    final List<DocumentSnapshot> thirdPartyDocuments = thirdPartySnapshot.docs;
    thirdPartyLinks = thirdPartyDocuments
        .map((doc) => ExternalLink(
              title: doc['title'],
              link: doc['link'],
            ))
        .toList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("third_party")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    List<ExternalLink> links = snapshot.data!.docs
                        .map((doc) => ExternalLink(
                              title: doc['title'],
                              link: doc['link'],
                            ))
                        .toList();

                    return Column(
                      children: links.map((link) {
                        return Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  navigateToWebView(link.title, link.link);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mobilescreenHeight * 0.025),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: mobilescreenHeight * 0.025),
                                    padding: EdgeInsets.all(
                                        mobilescreenHeight * 0.015),
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset('images/Setting Icon.png',
                                              width: mobilescreenHeight * 0.025,
                                              height:
                                                  mobilescreenHeight * 0.025),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      mobilescreenHeight *
                                                          0.025),
                                              child: Text(
                                                link.title,
                                                style: TextStyle(
                                                    fontSize:
                                                        mobilescreenHeight *
                                                            0.025),
                                              ),
                                            ),
                                          ),
                                          Image.asset(
                                            'images/Arrow Left Icon.png',
                                            width: mobilescreenHeight * 0.025,
                                            height: mobilescreenHeight * 0.025,
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              //Change Design
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
