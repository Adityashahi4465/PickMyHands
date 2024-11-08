import 'package:flutter/material.dart';

import 'dart:io';
import 'package:provider/provider.dart' as provider;
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

import '../../../routes/route_utils.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';

class CounsellorCard extends StatelessWidget {
  final String name;
  // final String imageText;
  final String discription;
  final String id;
  final String experience;
  final String profileUrl;
  final String Degree;

const  CounsellorCard({
    required this.name,
    // required this.imageText,
    required this.id,
    required this.discription,
    required this.experience,
    required this.profileUrl,
    required this.Degree,
  });

  // late Uri _url = Uri.parse(url);
  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw 'Could not launch $_url';
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final width = MediaQuery.of(context).size.width;
    return Card(
      margin: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      elevation: 10,
      shadowColor: Colors.black,
      color: Colors.white,
      child: SizedBox(
        width: 200,
        // height: 360,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileUrl),
                radius: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: Text(name,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // width: width*0.,
                        color: Colors.blueGrey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 12),
                          child: Text(
                            Degree,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            color: Colors.red.shade100,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 12),
                              child: Text(
                                experience,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  discription,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigation.navigateToCounsellorAppointmentBook(context, id);
                  },
                  color: isDarkTheme ? Dcream : Lpurple1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Book Appoinment',
                      style: TextStyle(
                          color: isDarkTheme ? Dbrown1 : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minWidth: 80,
                  height: 50,
                  elevation: 5.0,
                ),
              )
            ],
          ), //Column
        ), //Padding
      ),
    );
  }
}
