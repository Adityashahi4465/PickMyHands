import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/constants/courses_constant.dart';
import '../../../../../core/utils/snackbar.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/font_provider.dart';
import '../../../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../../../auth/controller/auth_controller.dart';
import '../../../../user/controller/user_controller.dart';
import 'course_videos.dart';
import 'video.dart';

final List courses = [
  "Accessible Technology Skills",
  "Health and Wellness",
  "Financial Literacy",
  "Legal Rights and Responsibilities",
  "Personality and Gromming",
];

class EducationVideoCoursesView extends ConsumerWidget {
  EducationVideoCoursesView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final fontSize = ref.watch(fontSizesProvider);
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user_loading = ref.watch(userControllerProvider);
    final user = ref.watch(userProvider)!;
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Videos',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: fontSize.headingSize,
                ),
          ),
          actions: [
            Switch(
              activeColor: Dcream,
              value: notifier.isDark,
              onChanged: (value) => notifier.changeTheme(),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(),
                width: width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15,
                        top: 28,
                      ),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (1.12 / 0.9),
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 1,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  print(
                                      'fsldkjf ffffffffffff ${accessible_technology_skills}');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Videos(
                                        videoLinks:
                                            accessible_technology_skills,
                                        courseTitle: courses[0],
                                      ),
                                    ),
                                  );

                                  break;
                                case 1:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Videos(
                                        videoLinks: health_and_wellness,
                                        courseTitle: courses[1],
                                      ),
                                    ),
                                  );
                                  break;
                                case 2:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Videos(
                                        videoLinks: financial_literacy,
                                        courseTitle: courses[2],
                                      ),
                                    ),
                                  );
                                  break;
                                case 3:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Videos(
                                        videoLinks:
                                            legal_rights_and_responsibilities,
                                        courseTitle: courses[3],
                                      ),
                                    ),
                                  );
                                  break;
                                case 4:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Videos(
                                        videoLinks: personality_and_grooming,
                                        courseTitle: courses[4],
                                      ),
                                    ),
                                  );
                                  break;

                                default:
                                  // Handle any undefined index
                                  Fluttertoast.showToast(
                                    msg: "This page is under construction",
                                  );
                                  break;
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isDarkTheme ? Dcream : Lpurple1,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.3,
                                    blurRadius: 1,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Image.asset(imgData[index]),
                                  Text(
                                    courses[index],
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          fontSize: fontSize.fontSize,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.red.shade400,
          shape: const CircleBorder(),
          onPressed: () {
            // Get.to(() => AddContactsPage());
            successSnackBar(
                context: context,
                message:
                    'Your Community "Jffffffffffffffffffffff" Created Successfully!',
                title: 'Success');
          },
          child: const Icon(
            Icons.sos_rounded,
            size: 48,
            color: Dbrown1,
          ),
          elevation: 2.0,
        ),
      );
    });
  }
}
