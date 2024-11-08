import 'package:flutter/material.dart';

import '../../../../../core/constants/courses_constant.dart';
import '../videos/education_videos.dart';
import 'text_reading_screen.dart';
class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Materials'),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: ListView.builder(
          itemCount: reading_material.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  courses[index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.notes_outlined),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => ReadingText(
                          content: reading_material[index],
                          title: courses[index],
                        )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
