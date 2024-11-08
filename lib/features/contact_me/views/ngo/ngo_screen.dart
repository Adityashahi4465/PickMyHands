import 'package:flutter/material.dart';

// import 'package:power_she_pre/screens/safety_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../../dashboard/widgets/bottom_bar.dart';
import '../../widgets/ngo_card.dart';

class NgoScreen extends StatefulWidget {
  const NgoScreen({super.key});

  @override
  State<NgoScreen> createState() => _NgoScreenState();
}

class _NgoScreenState extends State<NgoScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "NGOs",
              style: TextStyle(
                  color: isDarkTheme ? Colors.white : Lcream, fontSize: 24),
            ),
            actions: [
              Switch(
                  activeColor: Dcream,
                  value: notifier.isDark,
                  onChanged: (value) => notifier.changeTheme()),
            ],
          ),
          body: Scaffold(
            body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('ngos').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Container(
                          child: CardLayout(
                            imageUrl: document['image'],
                            serviceCategory: document['category'],
                            discription: document['discription'],
                            Title: document['name'],
                            location: document['location'],
                            forWhom: document['forWhom'],
                            number: document['mobile'],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    });
  }
}
