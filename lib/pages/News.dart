import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsData {
  final String image;
  final String title;
  final String content;

  NewsData({required this.image, required this.title, required this.content});
}

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<NewsData> newsData = [];
  bool _isLoading = true;
  final transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _fetchNewsData();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _fetchNewsData() async {
    final newsSnapshot =
        await FirebaseFirestore.instance.collection("news").get();
    final List<DocumentSnapshot> newsDocuments = newsSnapshot.docs;
    newsData = newsDocuments
        .map((doc) => NewsData(
              image: doc['imageUrl'],
              title: doc['title'],
              content: doc['content'],
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
      appBar: AppBar(
        title: Text(
          'News',
          style: TextStyle(fontSize: mobilescreenHeight * 0.028),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : newsData.isEmpty
                  ? const Center(child: Text('No news available'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(top: 10, left: 10, right: 10),
                          //   child: Text(
                          //     "News",
                          //     style: TextStyle(
                          //       fontSize: 32,
                          //       fontStyle: FontStyle.italic,
                          //       // decoration: TextDecoration.underline
                          //     ),
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ),
                          Container(
                            color: Colors.grey[350],
                            child: Column(
                              children: newsData.map((news) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: mobilescreenHeight * 0.01),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          mobilescreenHeight * 0.015),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Image.asset("images/segi_blackboard.png"),
                                          // Text('Title'),
                                          // Text('Content')
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: mobilescreenHeight *
                                                      0.01),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenImage(
                                                        imageUrl: news.image,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: news.image,
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  fit: BoxFit.contain,
                                                  // height: 100,
                                                  // width: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            news.title,
                                            style: TextStyle(
                                              fontSize:
                                                  mobilescreenHeight * 0.025,
                                            ),
                                          ),
                                          Text(
                                            news.content,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontSize:
                                                    mobilescreenHeight * 0.018),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black,
          child: Center(
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.1,
              maxScale: 4.0,
              child: Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
