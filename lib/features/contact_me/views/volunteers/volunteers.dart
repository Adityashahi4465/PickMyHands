import 'package:flutter/material.dart';

// import 'package:power_she_pre/screens/safety_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/firebase_constants.dart';
import '../../../../core/common/loader.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/font_provider.dart';
import '../../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../../dashboard/widgets/bottom_bar.dart';
import '../../widgets/counsellow_card.dart';
import '../../widgets/volunteers_card.dart';

class Volunteers extends ConsumerStatefulWidget {
  const Volunteers({super.key});

  @override
  ConsumerState<Volunteers> createState() => _VolunteersState();
}

class _VolunteersState extends ConsumerState<Volunteers> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final fontsize = ref.watch(fontSizesProvider);

    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Volunteers Services",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: fontsize.headingSize,
                  ),
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
              stream: FirebaseFirestore.instance
                  .collection(FirebaseConstants.volunteersCollection)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Loader();
                } else {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Container(
                          child: VolunteersCard(
                            name: document['name'],
                            id: document['id'],
                            discription: document['discription'],
                            experience: document['experience'],
                            profileUrl: document['profileUrl'],
                            Degree: document['Degree'],
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
