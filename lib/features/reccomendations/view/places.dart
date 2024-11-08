import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'map_screen.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: Stack(
        children: [
          // Map widget for user's current location
          // Replace this with your actual map implementation
          Positioned.fill(child: MyMap()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Reports'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportsPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Recommend'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecommendationsPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _reports = [];
  bool _isloding = true;
  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    QuerySnapshot querySnapshot = await _firestore.collection('reports').get();
    setState(() {
      _reports = querySnapshot.docs;
      _isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: _isloding
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    _reports[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(
                      data['title'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: RatingBar.builder(
                      initialRating: data['rating'],
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (value) => {},
                    ),
                    subtitle: Text(
                      data['description'].length > 50
                          ? '${data['description'].substring(0, 50)}...'
                          : data['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['description'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (data['location'] != null) {
                                  launchUrl(Uri.parse(data['location']));
                                } else {
                                  print('Location link is null');
                                }
                              },
                              child: const Text(
                                'View on Google Maps',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReportPage()),
          );
          // Navigate to a new page to add a report
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Similar code for RecommendationsPage...
class RecommendationsPage extends StatefulWidget {
  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _recommendations = [];
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('recommendations').get();
    setState(() {
      _recommendations = querySnapshot.docs;
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: _isloading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    _recommendations[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    shape: Border.all(color: Colors.black),
                    title: Text(
                      data['title'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: RatingBar.builder(
                      initialRating: data['rating'],
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (value) => {},
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['description'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (data['location'] != null) {
                                  launchUrl(Uri.parse(data['location']));
                                } else {
                                  print('Location link is null');
                                }
                              },
                              child: const Text(
                                'View on Google Maps',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecommendationPage()),
          );
          // Navigate to a new page to add a recommendation
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddRecommendationPage extends StatefulWidget {
  @override
  _AddRecommendationPageState createState() => _AddRecommendationPageState();
}

class _AddRecommendationPageState extends State<AddRecommendationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _rating = 0;
  double _latitude = 0;
  double _longitude = 0;
  Future<void> addRecommendation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;
    String googleMapsLink = 'https://maps.google.com/?q=$_latitude,$_longitude';

    await _firestore.collection('recommendations').add({
      'title': _title,
      'description': _description,
      'rating': _rating,
      'location': googleMapsLink,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recommendation'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  addRecommendation();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddReportPage extends StatefulWidget {
  @override
  _AddReportPageState createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _rating = 0;
  double _latitude = 0;
  double _longitude = 0;

  Future<void> addReport() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;
    String googleMapsLink = 'https://maps.google.com/?q=$_latitude,$_longitude';

    await _firestore.collection('reports').add({
      'title': _title,
      'description': _description,
      'rating': _rating,
      'location': googleMapsLink,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  addReport();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
