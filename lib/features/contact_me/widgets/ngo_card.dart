import 'package:flutter/material.dart';

import 'dart:io';
import 'package:provider/provider.dart' as provider;
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';

class CardLayout extends StatelessWidget {
  final String Title;
  // final String imageText;
  final String discription;
  final String serviceCategory;
  final String imageUrl;
  final String location;
  final String forWhom;
  final String number;

  CardLayout(
      {required this.Title,
      // required this.imageText,
      required this.discription,
      required this.serviceCategory,
      required this.imageUrl,
      required this.location,
      required this.forWhom,
      required this.number});

  // late Uri _url = Uri.parse(url);
  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw 'Could not launch $_url';
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    Uri dialNumber = Uri(scheme: 'tel', path: number);
    callNumber() async {
      await launchUrl(dialNumber);
    }

    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final width = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      // image: AssetImage('images/OprCard.png),
                      image: NetworkImage(imageUrl),
                    ),
                  ),
                ), // Container
              ), //Text
              const SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: Text(Title,
                        style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // width: width*0.,
                    color: Colors.blueGrey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 12),
                      child: Text(
                        "For: ${forWhom}",
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
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
                            serviceCategory,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  discription,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.yellow.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Text(
                            location,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  MaterialButton(
                    onPressed: () {
                      //
                      callNumber();
                    },
                    color: isDarkTheme ? Dcream : Lpurple1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(
                                color: isDarkTheme ? Dbrown1 : Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          Icon(
                            Icons.call,
                            color: isDarkTheme
                                ? Colors.green.shade800
                                : Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ), //Column
        ), //Padding
      ),
    );
  }
}
